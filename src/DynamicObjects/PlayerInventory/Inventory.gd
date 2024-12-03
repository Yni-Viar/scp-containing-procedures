extends Node
class_name Inventory

signal update_inventory

@export var inventory_storage: Array[Item] = []
@export var size: int:
	set(val):
		size = val
		inventory_storage.clear()
		if val > 1:
			for i in range(size):
				inventory_storage.append(null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Adds item as last
func add_item(item: Item) -> bool:
	for i in range(size):
		if inventory_storage[i] != null:
			continue
		else:
			inventory_storage[i] = item
			update_inventory.emit()
			return true
	printerr("The max item limit is reached")
	return false
## Sets item by id
func set_item(id: int, item: Item) -> bool:
	if id > size || id < 0:
		printerr("Value not valid")
		return false
	inventory_storage[id] = item
	update_inventory.emit()
	return true
## Finds and removes item.
func remove_item(item: Item) -> bool:
	for i in range(size):
		if inventory_storage[i] != null:
			continue
		elif inventory_storage[i] == item:
			inventory_storage[i] = null
			update_inventory.emit()
			return true
	return false

func find_item(item_name: String) -> Item:
	for inv in inventory_storage:
		if inv.name == item_name:
			return inv
	return null
