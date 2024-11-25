extends Resource
## Game DB.
## Made by Yni, licensed under MIT license.
class_name GameData

@export var puppet_classes: Array[PuppetClass]
## Available inventory items
@export var items: Array[Item]


# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_items: Array[Item] = []):
	items = p_items
