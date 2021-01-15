extends Node2D

onready var marker = $Marker

var disabled: bool = false


func _process(_delta: float) -> void:
	if disabled:
		hide()
		return
	
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_marker_position(Rect2(top_left, size))
	
	global_rotation = 0


func set_marker_position(bounds: Rect2) -> void:
	var canvas_scale = get_canvas_transform().get_scale()
	var x_offset = 5 / canvas_scale.x
	var y_offset = 5 / canvas_scale.y + 15
	marker.global_position.x = clamp(global_position.x, bounds.position.x + x_offset, bounds.end.x - x_offset)
	marker.global_position.y = clamp(global_position.y, bounds.position.y + y_offset, bounds.end.y - y_offset)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
