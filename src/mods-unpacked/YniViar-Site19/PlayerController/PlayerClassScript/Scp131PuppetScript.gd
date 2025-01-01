extends BasePuppetScript
## SCP-131 puppet script
## Created by Yni, licensed under dual license: for SCP content - GPL 3, for non-SCP - MIT License

var timer: float = 5.0

# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	update_targets(delta)

func update_targets(delta: float) -> void:
	if timer > 0:
		timer -= delta
	else:
		if active_puppets.size() > 0:
			get_parent().set_movement_target(active_puppets[0].global_position, true, false)
			if get_parent().get_node("NavigationAgent3D").is_target_reachable():
				get_parent().automatic = true
				active_puppets[0].get_parent().get_node("Puppet").freeze = true
				$AnimationPlayer.play("131_Panic")
		timer = 5.0
