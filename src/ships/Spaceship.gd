extends KinematicBody2D

signal update_resources(value)
signal show_dialog(text)
signal remove_dialog()
signal show_sell_dialog(amount)

onready var movement_controller = $MovementController
onready var gathering_timer: Timer = $GatheringTimer

var resources_held: int = 0 setget set_resources_held
var planet_target: Planet = null


func _process(_delta: float) -> void:
	if planet_target and not movement_controller.is_accelerating():
		movement_controller.stop_movement()
	
	update()


func sell_resources() -> void:
	print("selling resources")
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.MERCHANT:
		resources_held -= planet_target.get_requested_amount()
		planet_target.sell_resources()
		emit_signal("update_resources", resources_held)


func _draw() -> void:
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_regenerate:
		draw_line(global_position - global_position, planet_target.global_position - global_position, Color("fbf5ef"), 5.0)


func _on_InteractionArea_body_entered(body: Node) -> void:
	if planet_target:
		return
		
	var planet = body as Planet
	if planet:
		if planet.PLANET_TYPE == Planet.PlanetType.RESOURCE:
			print("gathering resources from: " + str(body))
		elif planet.PLANET_TYPE == Planet.PlanetType.MERCHANT:
			if planet.can_buy and resources_held >= planet.get_requested_amount():
				emit_signal("show_sell_dialog", planet.get_requested_amount())
			else:
				emit_signal("show_dialog", planet.get_dialog())
		planet_target = planet


func _on_InteractionArea_body_exited(body: Node) -> void:
	if planet_target and planet_target == body:
		if planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE:
			print("stopped gathering from " + str(body))
		elif planet_target.PLANET_TYPE == Planet.PlanetType.MERCHANT:
			emit_signal("remove_dialog")
		planet_target = null


func _on_GatheringTimer_timeout() -> void:
	if planet_target != null and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_consume():
		planet_target.consume_resource()
		self.resources_held += 1

func set_resources_held(value: int) -> void:
	resources_held = value
	emit_signal("update_resources", resources_held)


func camera_zoom_updated(zoom_amount) -> void:
	if zoom_amount == 1:
		movement_controller.max_speed = movement_controller.CLOSE_MAX_SPEED
	else:
		movement_controller.max_speed = movement_controller.FAR_MAX_SPEED

