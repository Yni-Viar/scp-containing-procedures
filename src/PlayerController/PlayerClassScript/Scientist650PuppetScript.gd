extends HumanPuppetScript


# Called when the node enters the scene tree for the first time.
func on_start() -> void:
	get_parent().get_node("VisionArea").connect("body_entered", on_vision_area_body_entered)
	await get_tree().create_timer(0.5).timeout
	get_parent().get_node("VisionArea").disconnect("body_entered", on_vision_area_body_entered)


func on_vision_area_body_entered(body: Node3D):
	if body is NpcSelection:
		if body.get_parent().fraction == 2 && state == States.IDLE:
			var offset: Vector3 = body.global_position
			offset.y = 0
			get_parent().look_at(offset)
