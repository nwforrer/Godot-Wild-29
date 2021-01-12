extends Node

export(NodePath) var CONTROLLING_NODE
onready var controlling_node: Node = get_node(CONTROLLING_NODE)

export(float) var GATHER_SPEED = 1.0

onready var timer = $Timer

var planet_target: Planet = null setget set_planet_target


func _ready() -> void:
	timer.wait_time = GATHER_SPEED


func disable_gathering() -> void:
	timer.stop()


func enable_gathering() -> void:
	timer.start()


func set_planet_target(planet: Planet) -> void:
	planet_target = planet
	if planet:
		timer.start()
	else:
		timer.stop()


func _on_Timer_timeout() -> void:
	if planet_target != null and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_consume():
		planet_target.consume_resource()
		controlling_node.resources_held += 1
