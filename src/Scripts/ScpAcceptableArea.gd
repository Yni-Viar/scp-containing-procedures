extends Area3D

@export var scp_to_check: String = "SCP"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_exited(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().puppet_class.puppet_class_name == scp_to_check && !get_tree().root.get_node("Game/FoundationTask").scps_outside_container.has(scp_to_check):
			get_tree().root.get_node("Game/FoundationTask").secure_contain_protect(false, scp_to_check)


func _on_body_entered(body: Node3D) -> void:
	if body is NpcSelection:
		if body.get_parent().puppet_class.puppet_class_name == scp_to_check && get_tree().root.get_node("Game/FoundationTask").scps_outside_container.has(scp_to_check):
			get_tree().root.get_node("Game/FoundationTask").secure_contain_protect(true, scp_to_check)
