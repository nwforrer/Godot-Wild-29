extends Control


func _on_CloseButton_pressed() -> void:
	get_tree().paused = false
	SoundEffects.select_sound.play()
	queue_free()
