extends Node

onready var pause_ui := get_node("../GUI/PauseMenu")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_toggle_pause_game()


func _toggle_pause_game() -> void:
	if pause_ui.is_visible_in_tree():
		get_tree().paused = false
		pause_ui.hide()
	else:
		get_tree().paused = true
		pause_ui.show()
