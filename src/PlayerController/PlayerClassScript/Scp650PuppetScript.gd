extends VisionScpPuppetScript

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@export var wait_seconds: float = 5
var timer = 0

# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#If is not watching
	if watching_puppets.size() == 0:
		#Wait
		timer += delta
		if timer >= wait_seconds:
			var random_human: Node3D = active_puppets[rng.randi_range(0, active_puppets.size() - 1)]
			#Action. We move SCP-650 to player's global position - offset (which is transform.basis.z) * how far SCP-650 will be from player
			global_position = random_human.global_position - random_human.global_transform.basis.z * 2
			set_state("Pose " + str(rng.randi_range(4, 10)))
			# Look at player
			look_at(random_human.global_position)
			# reset timer
			timer = 0
	else:
		# reset timer
		timer = 0



## Animation state
func set_state(s):
	# if animation is the same, do nothing, else play new animation
	if $AnimationPlayer.current_animation == s:
		return
	$AnimationPlayer.play(s, 0.3)
