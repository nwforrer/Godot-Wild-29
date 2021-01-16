extends KinematicBody2D

export(int) var num_miners = 0 setget set_num_miners
export(bool) var miners_unlocked = false

signal update_miner_count(value)

onready var movement_controller = $MovementController
onready var gathering_component = $GatheringComponent
onready var miner_detector = $MinerDetector

var Miner = preload("res://src/ships/Miner.tscn")

var resources_held: int = 0 setget set_resources_held
var planet_target: Planet = null setget set_planet_target


func _process(_delta: float) -> void:
	if planet_target and not movement_controller.is_accelerating():
		movement_controller.stop_movement()


func _physics_process(_delta: float) -> void:
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE:
		var raycast_dir = (planet_target.global_position - global_position).normalized()
		miner_detector.global_rotation = raycast_dir.angle()
		if miner_detector.is_colliding():
			var colliding_miner = miner_detector.get_collider() as Miner
			if colliding_miner and colliding_miner.job_complete and colliding_miner.owning_ship == self:
				self.resources_held += colliding_miner.resources_held
				colliding_miner.queue_free()
				self.num_miners += 1


func stop_moving_immediately() -> void:
	movement_controller.stop_movement_immediately()


func set_planet_target(planet: Planet) -> void:
	planet_target = planet
	gathering_component.planet_target = planet
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE:
		miner_detector.enabled = true
	else:
		miner_detector.enabled = false


func _on_InteractionArea_body_entered(body: Node) -> void:
	if planet_target:
		return
		
	var planet = body as Planet
	if planet:
		self.planet_target = planet


func _on_InteractionArea_body_exited(body: Node) -> void:
	if planet_target and planet_target == body:
		self.planet_target = null


func _launch_miner():
	if num_miners == 0:
		return
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_regenerate:
		var miner = Miner.instance()
		get_tree().current_scene.add_child(miner)
		miner.global_position = global_position
		miner.launch(self, planet_target)
		self.num_miners -= 1


func set_resources_held(value: int) -> void:
	resources_held = value


func set_num_miners(value: int) -> void:
	num_miners = value
	emit_signal("update_miner_count", value)


func consume_resource():
	if resources_held > 0:
		self.resources_held -= 1
