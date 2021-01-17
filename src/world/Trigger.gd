extends Node2D


export(Array, NodePath) var unlock_objects = []


func _on_VisibilityNotifier2D_screen_exited() -> void:
	for object in unlock_objects:
		var o = get_node(object)
		if o.has_method("unlock"):
			o.unlock()
		else:
			print(str(o) + " is missing unlock method.")
	queue_free()


func unlock() -> void:
	queue_free()
