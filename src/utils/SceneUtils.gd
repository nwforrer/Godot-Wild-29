extends Node

onready var previous_scene := get_tree().current_scene.filename
var previous_was_popup := false
var previous_popup: Control = null


func change_scene(scene: String) -> void:
	previous_was_popup = false
	previous_scene = get_tree().current_scene.filename
	# warning-ignore:return_value_discarded
	get_tree().change_scene(scene)


func open_popup(node_path: String) -> void:
	previous_was_popup = true
	previous_popup = load(node_path).instance()
	get_tree().current_scene.get_node("GUI").add_child(previous_popup)


func goto_previous_scene() -> void:
	if previous_was_popup:
		previous_popup.queue_free()
	else:
		change_scene(previous_scene)

