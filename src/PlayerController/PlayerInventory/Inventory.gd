extends Node

@export var inventory_storage: Array[Item] = []
@export var size: int:
	set(val):
		inventory_storage.clear()
		if val > 1:
			for i in range(size):
				inventory_storage.append(null)
		size = val

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Adds item as last
func add_item(item: Item):
	for i in range(size):
		if inventory_storage[i] == null:
			continue
		else:
			inventory_storage[i] = item
	printerr("The max item limit is reached")
## Sets item by id
func set_item(id: int, item: Item):
	if id > size || id < 0:
		printerr("Value not valid")
		return
	inventory_storage[id] = item
## Finds and removes item.
func remove_item(item: Item):
	for i in range(size):
		if inventory_storage[i] != null:
			continue
		elif inventory_storage[i] == item:
			inventory_storage[i] = null
