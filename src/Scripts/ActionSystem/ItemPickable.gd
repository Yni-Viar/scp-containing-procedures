extends InteractableRigidBody
class_name ItemPickable

@export var item: Item

func interact(player: Node3D):
	if player != null:
		if player.get_node("Inventory").add_item(item):
			queue_free()

func use(player: Node3D) -> void:
	pass
