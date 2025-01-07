extends BasePuppetScript
## SCP-049 puppet script
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License
class_name Scp049PlayerScript

signal cured(puppet_team: int)

enum Mood {NORMAL, AGGRESSIVE, CURING}

@export var mood: Mood = Mood.NORMAL

var timer: float = 0.0
var chase_timer = 1.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var current_anim: String = ""
var current_human: Node3D
var raycast: RayCast3D

# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	raycast = get_parent().get_node("RayCastLow")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if get_parent().visible_on_screen:
		match state:
			States.IDLE:
				set_state("049_Idle2")
			States.WALKING:
				set_state("049_Walking")
			States.RUNNING:
				set_state("049_Running")
		if mood == Mood.AGGRESSIVE:
			scp_049_chase(delta)
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider is NpcSelection:
					var selected_pawn = collider.get_pawn()
					if selected_pawn.fraction == 0:
						get_tree().root.get_node("Game/NPCs").object_remover(selected_pawn.name)
						cured.emit(selected_pawn.puppet_class.team)
						active_puppets.erase(current_human)
						if active_puppets.size() == 0:
							mood = Mood.NORMAL
						else:
							current_human = active_puppets[rng.randi_range(0, active_puppets.size() - 1)]
	
	scp_049_mood_setter(delta)

func scp_049_mood_setter(delta: float) -> void:
	if timer > 0:
		timer -= delta
	else:
		if active_puppets.size() == 0:
			mood = Mood.NORMAL
		else:
			mood = rng.randi_range(0, 1)
		match mood:
			Mood.NORMAL:
				get_parent().wandering = true
				get_parent().automatic = false
				get_parent().character_speed = 1.8
			Mood.AGGRESSIVE:
				get_parent().wandering = false
				get_parent().automatic = true
				get_parent().character_speed = 3.0
				if active_puppets.size() > 0:
					current_human = active_puppets[rng.randi_range(0, active_puppets.size() - 1)]
				else:
					current_human = null
		timer = rng.randf_range(8.0, 15.0)

func scp_049_chase(delta: float):
	if chase_timer > 0:
		chase_timer -= delta
	else:
		get_parent().set_movement_target(current_human.global_position, false, true)
		chase_timer = 1.0

## Animation state
func set_state(s):
	# if animation is the same, do nothing, else play new animation
	if $AnimationPlayer.current_animation == s:
		return
	$AnimationPlayer.play(s, 0.3)
