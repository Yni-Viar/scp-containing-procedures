extends VisionScpPuppetScript
## SCP-173 puppet script
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License
class_name Scp173PuppetScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var faces: int = 10
@export var invincibility: bool = false
@export var blink_timer_default: float = 4.7
var blink_timer: float = blink_timer_default
var is_blinking: bool = false
var current_human: Node3D
var raycast: RayCast3D
var player_direction: Vector3
var movement_reset: bool = false

# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	raycast = get_parent().get_node("RayCastLow")
	#get_parent().get_node("ActionArea").connect("body_entered", on_action_area_body_entered)
	#get_parent().get_node("ActionArea").connect("body_exited", on_action_area_body_exited)
	set_face()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scp_173_blink(delta)
	# If is watching, set velocity to zero, else - go to player.
	if (is_blinking && watching_puppets.size() > 0 && current_human != null) || (watching_puppets.size() == 0 && current_human != null):
		scp_173_movement()
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is NpcSelection:
				var selected_pawn = collider.get_pawn()
				if selected_pawn.fraction == 0:
					get_parent().get_node("InteractSound").stream = load("res://ResourcePacks/Site19/Sounds/Characters/Scp173/NeckSnap.ogg")
					get_parent().get_node("InteractSound").play()
					get_tree().root.get_node("Game/NPCs").object_remover(selected_pawn.name)
					active_puppets.erase(current_human)
					current_human = null
					movement_reset = false
## Blink mechanic
func scp_173_blink(delta: float):
	# If blink timer > 0 - then wait
	if blink_timer > 0:
		blink_timer -= delta
	else:
		is_blinking = true
		movement_reset = false
		# Navigate to the human near you
		if active_puppets.size() > 0 && !active_puppets.has(current_human):
			current_human = active_puppets[rng.randi_range(0, active_puppets.size() - 1)]
		else:
			current_human = null
		await get_tree().create_timer(0.3).timeout
		blink_timer = blink_timer_default
		is_blinking = false
## Movement control
func scp_173_movement():
	if state == States.IDLE && !movement_reset:
		get_parent().set_movement_target(current_human.global_position + current_human.global_transform.basis.z * 2)
		movement_reset = true
## Set face on spawn
func set_face():
	var tex: ShaderMaterial = load("res://ResourcePacks/Site19/Assets/Materials/scp173.tres")
	tex.set_shader_parameter("albedo_b", load("res://ResourcePacks/Site19/Assets/ExternalModels/scp173/Faces/face_" + str(rng.randi_range(1, faces)) + ".png"))
	$SCP173_Rig/Skeleton3D/scp173_MESH.set_surface_override_material(0, tex)

#func on_action_area_body_exited(body: Node3D):
	#pass
