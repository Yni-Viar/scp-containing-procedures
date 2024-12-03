extends ItemPickable

var velocity: Vector3 = Vector3()

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision3D = move_and_collide(velocity)
	if collision != null:
		var collider = collision.get_collider(0)
		if collider is NpcSelection:
			collider.get_parent().call("health_manage", velocity.y * 2)
		if velocity.x < 0.08 && velocity.y < 0.08 && velocity.z < 0.08:
			velocity *= 2

func use(player: Node3D) -> void:
	position.y = 1
	velocity = -player.global_transform.basis.z * 0.125
	apply_impulse(velocity, player.global_transform.basis.z * 2)
