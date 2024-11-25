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

func object_spawner(puppet_class: PuppetClass, pos: Vector3):
	match types:
		0:
			var npc: NpcPlayerScript = load("res://PlayerController/NPCScene.tscn").instantiate()
			npc.puppet_class = puppet_class
			npc.position = pos
			add_child(npc, true)
			items.append(npc)
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
		_:
			printerr("Wrong type. Currently, only ENTITY is implemented...")
