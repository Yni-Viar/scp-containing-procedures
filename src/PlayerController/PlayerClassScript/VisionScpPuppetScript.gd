extends BasePuppetScript
class_name VisionScpPuppetScript

var watching_puppets: Array[Node3D] = []
var active_puppets: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_node("VisionArea").connect("body_entered", on_vision_area_body_entered)
	get_parent().get_node("VisionArea").connect("body_exited", on_vision_area_body_exited)
	on_start()

func on_start():
	pass


func on_vision_area_body_entered(body: Node3D):
	if body is NpcSelection:
		if body.get_parent().fraction == 0:
			active_puppets.append(body)

func on_vision_area_body_exited(body: Node3D):
	if body is NpcSelection:
		if body.get_parent().fraction == 0:
			active_puppets.erase(body)
