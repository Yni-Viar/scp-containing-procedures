extends Resource
class_name PuppetClass

@export var puppet_class_name: String
@export var speed: float = 3
@export var prefab: PackedScene
@export var spawn_point_group: String
@export var initial_amount: int
@export var automatic: bool
@export var footstep_sounds: Dictionary
## 0 is human, 1 is hostile SCP, 2 is vision SCP (like 650 and 173)
@export var fraction: int
@export var apply_height_bugfix: bool = true
@export var enable_wander: bool = true
@export var inventory_item_size: int = 0
