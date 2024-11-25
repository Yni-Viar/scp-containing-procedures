extends VisionScpPuppetScript
class_name Scp173PuppetScript


var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var faces: int = 10
@export var invincibility: bool = false
@export var blink_timer_default: float = 4.7
var blink_timer: float = blink_timer_default
var is_blinking: bool = false
var current_human: Node3D
var raycast: RayCast3D
var target_human: Node3D
var target_set: bool = false
var target_counter: int = 0

# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	raycast = get_parent().get_node("RayCast3D")
	#get_parent().get_node("ActionArea").connect("body_entered", on_action_area_body_entered)
	#get_parent().get_node("ActionArea").connect("body_exited", on_action_area_body_exited)
	set_face()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	scp_173_blink(delta)
	# If is watching, set velocity to zero, else - go to player.
	if is_blinking && watching_puppets.size() > 0 && active_puppets.size() > 0:
		var player_direction: Vector3 = global_position.direction_to(current_human.global_position)
		get_parent().set_movement_target(get_parent().global_position + get_parent().character_speed * player_direction)
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is NpcSelection:
				var selected_pawn = collider.get_pawn()
				if selected_pawn.fraction == 0:
					get_parent().get_node("InteractSound").stream = load("res://Sounds/Character/Scp173/NeckSnap.ogg")
					get_parent().get_node("InteractSound").play()
					get_tree().root.get_node("Game/NPCs").object_remover(selected_pawn.name)
	elif watching_puppets.size() == 0:
		if active_puppets.size() == 0:
			var player_direction: Vector3 = Vector3(rng.randf(), 0, rng.randf())
			get_parent().set_movement_target(get_parent().global_position + get_parent().character_speed * player_direction)
		elif current_human != null && !target_set:
			var player_direction: Vector3 = global_position.direction_to(current_human.global_position)
			get_parent().set_movement_target(get_parent().global_position + get_parent().character_speed * player_direction)
			target_human = current_human
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider is NpcSelection:
					var selected_pawn = collider.get_pawn()
					if selected_pawn.fraction == 0:
						get_parent().get_node("InteractSound").stream = load("res://Sounds/Character/Scp173/NeckSnap.ogg")
						get_parent().get_node("InteractSound").play()
						get_tree().root.get_node("Game/NPCs").object_remover(selected_pawn.name)
						current_human = null
						target_human = null
		elif is_blinking && active_puppets.size() > 1:
			if target_counter > 2:
				target_counter = 0
				target_human = current_human
			else:
				target_counter += 1

func scp_173_blink(delta: float):
	# for blink-based games
	if blink_timer > 0:
		blink_timer -= delta
	else:
		is_blinking = true
		if active_puppets.size() > 0:
			current_human = active_puppets[rng.randi_range(0, active_puppets.size() - 1)]
		await get_tree().create_timer(0.3).timeout
		blink_timer = blink_timer_default
		is_blinking = false


func set_face():
	var tex: ShaderMaterial = load("res://Assets/Materials/scp173.tres")
	tex.set_shader_parameter("albedo_b", load("res://Assets/ExternalModels/SCP/scp173/Faces/face_" + str(rng.randi_range(1, faces)) + ".png"))
	$SCP173_Rig/Skeleton3D/scp173_MESH.set_surface_override_material(0, tex)

#func on_action_area_body_exited(body: Node3D):
	#pass
