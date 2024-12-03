extends Node3D
class_name ObjectSystem

enum Types {ENTITY, ITEM, MAPOBJECT}

@export var types: Types = Types.ENTITY
var items: Array[Node3D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func object_spawner(res: Resource, pos: Vector3):
	match types:
		0:
			var npc: NpcPlayerScript = load("res://PlayerController/NPCScene.tscn").instantiate()
			if res is PuppetClass:
				npc.puppet_class = res
				npc.position = pos
				add_child(npc, true)
				items.append(npc)
			else:
				printerr("Wrong resource, not PuppetClass")
				return
		1:
			if res is Item:
				var item: ItemPickable = load(res.pickable_path).instantiate()
				item.position = pos
				add_child(item, true)
				items.append(item)
		_:
			printerr("Wrong type. Currently, only ENTITY is implemented...")

func object_remover(name_of_object: String, post_mortem: bool = false):
	match types:
		0:
			var npc: NpcPlayerScript = get_node(name_of_object)
			items.erase(npc)
			npc.queue_free()
			if post_mortem:
				return("Ragdolls are not implemented")
		1:
			var item: ItemPickable = get_node(name_of_object)
			items.erase(item)
			item.queue_free()
		_:
			printerr("Wrong type. Currently, only ENTITY is implemented...")
