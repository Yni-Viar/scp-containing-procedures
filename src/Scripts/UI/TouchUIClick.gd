extends TextureButton


func _on_button_up() -> void:
	Input.action_release("interact")


func _on_button_down() -> void:
	Input.action_press("interact")
