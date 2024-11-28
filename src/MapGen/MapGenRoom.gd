extends Resource
class_name MapGenRoom

@export var name: String
@export var prefab: PackedScene
@export var icon: Texture2D
@export_range(1, 100) var spawn_chance: float = 20
