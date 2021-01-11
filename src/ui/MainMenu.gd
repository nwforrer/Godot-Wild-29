extends Control


func _ready() -> void:
	VisualServer.set_default_clear_color(Color("272744"))


func _on_StartButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/world/World.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
