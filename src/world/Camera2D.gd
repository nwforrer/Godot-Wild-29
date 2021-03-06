extends Camera2D

signal camera_zoom_updated(zoom_amount)

enum ZoomState {
	NEAR = 1,
	FAR = 5,
}

export(float) var PLANET_ZOOM_DISTANCE = 150.0

var current_zoom_state = ZoomState.NEAR

var visible_planets: Array


func _ready() -> void:
	_determine_zoom()


func _process(delta: float) -> void:
	_determine_zoom()
	if current_zoom_state == ZoomState.NEAR and zoom.x != ZoomState.NEAR:
		var new_zoom = lerp(zoom.x, ZoomState.NEAR, delta)
		zoom = Vector2(new_zoom, new_zoom)
	elif current_zoom_state == ZoomState.FAR and zoom.x != ZoomState.FAR:
		var new_zoom = lerp(zoom.x, ZoomState.FAR, delta)
		zoom = Vector2(new_zoom, new_zoom)


func add_visible_planet(planet):
	if planet and not planet.is_queued_for_deletion():
		visible_planets.append(planet)


func remove_visible_planet(planet):
	visible_planets.append(planet)


func clear_visible_planets():
	visible_planets.clear()


func _determine_zoom():
	var new_zoom_level = ZoomState.FAR
	if visible_planets.size() > 0:
		for planet in visible_planets:
			if position.distance_to(planet.position) < PLANET_ZOOM_DISTANCE:
				new_zoom_level = ZoomState.NEAR
				break
	
	if current_zoom_state != new_zoom_level:
		emit_signal("camera_zoom_updated", new_zoom_level)
	current_zoom_state = new_zoom_level
