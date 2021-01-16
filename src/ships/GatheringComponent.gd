extends Node2D

export(NodePath) var CONTROLLING_NODE
onready var controlling_node: Node = get_node(CONTROLLING_NODE)

onready var gathering_particles = $GatheringParticles

export(float) var GATHER_SPEED = 1.0
export(bool) var visible_particles = true

onready var timer = $Timer

var planet_target: Planet = null setget set_planet_target
var ship_target = null setget set_ship_target


func _ready() -> void:
	timer.wait_time = GATHER_SPEED


func _process(_delta: float) -> void:
	if not visible_particles:
		return
	
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_regenerate:
		var particle_dir = -(planet_target.global_position - controlling_node.global_position).normalized()
		gathering_particles.global_position = planet_target.global_position
		gathering_particles.global_rotation = particle_dir.angle()
		gathering_particles.emitting = true
		gathering_particles.show()
	elif ship_target:
		var particle_dir = -(ship_target.global_position - controlling_node.global_position).normalized()
		gathering_particles.global_position = ship_target.global_position
		gathering_particles.global_rotation = particle_dir.angle()
		gathering_particles.emitting = true
		gathering_particles.show()
	else:
		gathering_particles.emitting = false
		gathering_particles.hide()
	
	update()


func _draw() -> void:
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE:
		draw_line(global_position - global_position, planet_target.global_position - global_position, Color("fbf5ef"), 5.0)
	elif ship_target:
		draw_line(global_position - global_position, ship_target.global_position - global_position, Color("fbf5ef"), 5.0)


func disable_gathering() -> void:
	timer.stop()


func enable_gathering() -> void:
	timer.start()


func set_planet_target(planet: Planet) -> void:
	if ship_target:
		return
	planet_target = planet
	if planet:
		timer.start()
	else:
		timer.stop()


func set_ship_target(ship) -> void:
	ship_target = ship
	if ship:
		if planet_target:
			planet_target = null
		timer.start()
	else:
		timer.stop()


func _on_Timer_timeout() -> void:
	if planet_target != null and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_consume():
		planet_target.consume_resource()
		controlling_node.resources_held += 1
	elif ship_target != null:
		ship_target.consume_resource()
		ship_target.consume_credit()
		controlling_node.resources_held += 1
