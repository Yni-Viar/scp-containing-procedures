extends HBoxContainer



func _on_tap_button_down() -> void:
	Input.action_press("interact")


func _on_tap_button_up() -> void:
	Input.action_release("interact")


func _on_map_button_down() -> void:
	Input.action_press("map_open")


func _on_map_button_up() -> void:
	Input.action_release("map_open")


func _on_tap_with_item_button_down() -> void:
	Input.action_press("interact_alt")


func _on_tap_with_item_button_up() -> void:
	Input.action_release("interact_alt")
