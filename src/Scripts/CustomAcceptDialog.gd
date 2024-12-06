extends AcceptDialog



func _on_canceled() -> void:
	queue_free()


func _on_confirmed() -> void:
	queue_free()
