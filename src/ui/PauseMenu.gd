extends CenterContainer


func _on_ResumeButton_pressed() -> void:
	_resume()


func _resume() -> void:
	get_tree().paused = false
	hide()


func _on_OptionsButton_pressed() -> void:
	SceneUtils.open_popup("res://src/ui/OptionsMenu.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
