extends Area3D

var frozen: bool = false
var dclass_entered_array: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().root.get_node("Game/FoundationTask").has_task("S19_TEST_266"):
		get_tree().root.get_node("Game/NPCs").object_removed.connect(_on_dclass_frozen)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dclass_frozen(item: Node3D) -> void:
	if item is NpcPlayerScript:
		if dclass_entered_array.has(item.get_node("NpcSelection")):
			dclass_entered_array.clear()
			get_tree().root.get_node("Game/FoundationTask").do_task("S19_TEST_266")


func _on_body_entered(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().puppet_class.fraction == 0 && body.get_parent().puppet_class.team == 2: # d-class
			dclass_entered_array.append(body)
