extends Control


func _ready() -> void:
	VisualServer.set_default_clear_color(Color("272744"))


func _on_StartButton_pressed() -> void:
	SoundEffects.select_sound.play()
	SceneUtils.change_scene("res://src/ui/IntroDialog.tscn")


func _on_QuitButton_pressed() -> void:
	SoundEffects.select_sound.play()
	get_tree().quit()


func _on_OptionsButton_pressed() -> void:
	SoundEffects.select_sound.play()
	SceneUtils.change_scene("res://src/ui/OptionsMenu.tscn")
