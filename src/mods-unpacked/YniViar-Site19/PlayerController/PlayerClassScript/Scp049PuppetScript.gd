extends BasePuppetScript

enum Mood {NORMAL, AGGRESSIVE, CURING}

@export var mood: Mood = Mood.NORMAL

var timer: float = 15.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var current_anim: String = ""

# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		States.IDLE:
			set_anim_state("049_Idle2")
		States.WALKING:
			set_anim_state("049_Walking")
		States.RUNNING:
			set_anim_state("049_Running")
	scp_049_mood_setter(delta)

func scp_049_mood_setter(delta: float) -> void:
	if timer > 0:
		timer -= delta
	else:
		mood = rng.randi_range(0, 1)
		match mood:
			Mood.NORMAL:
				get_parent().wandering = true
			Mood.AGGRESSIVE:
				get_parent().wandering = false
		timer = rng.randf_range(8.0, 15.0)

func set_anim_state(animation_name: String):
	if animation_name != $AnimationPlayer.current_animation:
		$AnimationPlayer.play(animation_name)
