extends Node3D
## Made by Yni, licensed under CC0.
class_name BasePuppetScript

@export var armature_name: String = "HumanRig"
enum States {IDLE, WALKING, RUNNING, SPECIAL1, SPECIAL2, SPECIAL3, SPECIAL4}
@export var state: States = States.IDLE
@export var enable_vision_scan: bool = false
@export var vision_class_detect: int = 0
@export var wandering: bool = false
var active_puppets: Array[Node3D] = []

func _ready() -> void:
	if enable_vision_scan:
		get_parent().get_node("VisionArea").connect("body_entered", on_vision_area_body_entered)
		get_parent().get_node("VisionArea").connect("body_exited", on_vision_area_body_exited)
	# Inventory items
	get_parent().get_node("Inventory").size = get_parent().puppet_class.inventory_item_size
	wandering = get_parent().puppet_class.enable_wander
	for item in get_parent().puppet_class.initial_items:
		get_parent().get_node("Inventory").add_item(item)
	on_start()

func on_start():
	pass

func _physics_process(delta: float) -> void:
	
	on_update(delta)

func on_update(delta: float):
	pass

func on_vision_area_body_entered(body: Node3D):
	if body is NpcSelection:
		if body.get_parent().fraction == vision_class_detect:
			active_puppets.append(body)

func on_vision_area_body_exited(body: Node3D):
	if body is NpcSelection:
		if body.get_parent().fraction == vision_class_detect:
			active_puppets.erase(body)
