extends Area3D

var d_class_entered_amount: int = 0
var foundation_amount: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().puppet_class.team == 1:
			foundation_amount += 1
		if d_class_entered_amount >= 2 && foundation_amount >= 2:
			get_tree().root.get_node("Game/FoundationTask").do_task("S19_CLEAN_173")

func _on_body_exited(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().puppet_class.team == 1:
			foundation_amount -= 1


func _on_scp_acceptable_area_body_entered(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().puppet_class.puppet_class_name == "SCP-131": # 131
			d_class_entered_amount += 1
			# in future, calling 131 will grant additional points
		if body.get_parent().puppet_class.team == 2: # d-class
			d_class_entered_amount += 1
		if d_class_entered_amount >= 2 && foundation_amount >= 2:
			get_tree().root.get_node("Game/FoundationTask").do_task("S19_CLEAN_173")
