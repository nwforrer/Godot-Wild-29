extends Node

enum AiState {
	EXTRACT_RESOURCES,
	CHASE_PLAYER,
}

export(NodePath) var MovementController
onready var movement_controller: MovementController = get_node(MovementController)
export(NodePath) var GatheringComponent
onready var gathering_component = get_node(GatheringComponent)

onready var acceleration_timer = $AccelerationTimer
onready var chase_timer = $ChaseTimer

var ai_state = AiState.EXTRACT_RESOURCES

var player_ship = null

var resource_planets: Array
var destination: Planet


func _process(_delta: float) -> void:
	match ai_state:
		AiState.CHASE_PLAYER:
			movement_controller.movement_dir = (player_ship.global_position - get_parent().global_position).normalized()


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


func chase_player(player) -> void:
	player_ship = player
	ai_state = AiState.CHASE_PLAYER
	chase_timer.start()


func _on_destination_resources_exhausted(planet) -> void:
	resource_planets.erase(planet)
	if planet == destination:
		choose_desination()


func _on_AccelerationTimer_timeout() -> void:
	movement_controller.movement_dir = Vector2.ZERO


func _on_PirateBoardingArea_body_entered(body: Node) -> void:
	if ai_state == AiState.CHASE_PLAYER:
		gathering_component.ship_target = body


func _on_PirateBoardingArea_body_exited(body: Node) -> void:
	if ai_state == AiState.CHASE_PLAYER:
		gathering_component.ship_target = null


func _on_ChaseTimer_timeout() -> void:
	ai_state = AiState.EXTRACT_RESOURCES
	choose_desination()
