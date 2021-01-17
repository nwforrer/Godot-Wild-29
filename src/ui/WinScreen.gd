extends Control


func _on_PlayAgainButton_pressed() -> void:
	SoundEffects.select_sound.play()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/world/World.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
