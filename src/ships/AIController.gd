extends Node

export(NodePath) var MovementController
onready var movement_controller: MovementController = get_node(MovementController)

onready var acceleration_timer = $AccelerationTimer

var resource_planets: Array
var destination: Planet


func add_resource_planet(planet) -> void:
	resource_planets.append(planet)
	planet.connect("resources_exhausted", self, "_on_destination_resources_exhausted")


func start_ai() -> void:
	choose_desination()


func choose_desination() -> void:
	if resource_planets.size() > 0:
		resource_planets.shuffle()
		destination = resource_planets[0]
		movement_controller.movement_dir = (destination.global_position - get_parent().global_position).normalized()
		acceleration_timer.start()


func _on_destination_resources_exhausted(planet) -> void:
	resource_planets.erase(planet)
	if planet == destination:
		choose_desination()


func _on_AccelerationTimer_timeout() -> void:
	movement_controller.movement_dir = Vector2.ZERO
