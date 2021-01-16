extends Control


func _ready() -> void:
	VisualServer.set_default_clear_color(Color("272744"))


func _on_StartButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	SoundEffects.select_sound.play()
	get_tree().change_scene("res://src/ui/IntroDialog.tscn")


func _on_QuitButton_pressed() -> void:
	SoundEffects.select_sound.play()
	get_tree().quit()
