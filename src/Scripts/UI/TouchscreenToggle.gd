extends Control
## Touch screen controls
## Created by Yni, licensed under MIT License

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Settings.touchscreen:
		show()
	set_process(false)
	set_physics_process(false)
