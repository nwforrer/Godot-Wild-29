extends KinematicBody2D

onready var movement_controller = $MovementController
onready var gathering_timer: Timer = $GatheringTimer
onready var gathering_particles = $GatheringParticles

var resources_held: int = 0 setget set_resources_held
var planet_target: Planet = null


func _process(_delta: float) -> void:
	if planet_target and not movement_controller.is_accelerating():
		movement_controller.stop_movement()
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_regenerate:
		var particle_dir = -(planet_target.global_position - global_position).normalized()
		gathering_particles.global_position = planet_target.global_position
		gathering_particles.global_rotation_degrees = rad2deg(particle_dir.angle())
		gathering_particles.emitting = true
		gathering_particles.show()
	else:
		gathering_particles.emitting = false
		gathering_particles.hide()
	
	update()


func _draw() -> void:
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_regenerate:
		draw_line(global_position - global_position, planet_target.global_position - global_position, Color("fbf5ef"), 5.0)


func _on_InteractionArea_body_entered(body: Node) -> void:
	if planet_target:
		return
		
	var planet = body as Planet
	if planet:
		planet_target = planet


func _on_InteractionArea_body_exited(body: Node) -> void:
	if planet_target and planet_target == body:
		planet_target = null


func _on_GatheringTimer_timeout() -> void:
	if planet_target != null and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_consume():
		planet_target.consume_resource()
		self.resources_held += 1

func set_resources_held(value: int) -> void:
	resources_held = value
