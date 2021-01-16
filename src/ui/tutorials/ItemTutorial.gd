extends Control


func _on_CloseButton_pressed() -> void:
	get_tree().paused = false
	queue_free()
