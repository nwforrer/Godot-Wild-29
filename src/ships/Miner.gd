extends KinematicBody2D
class_name Miner

export(int) var MAX_RESOURCES = 5

onready var movement_controller = $MovementController
onready var gathering_component = $GatheringComponent
onready var resources_full = $ResourcesFullIndicator
onready var collider = $CollisionShape2D

var planet_target: Planet = null
var resources_held: int = 0 setget set_resources_held


func launch(target: Planet) -> void:
	planet_target = target
	var direction = (target.global_position - global_position).normalized()
	global_rotation = direction.angle() - deg2rad(90)
	movement_controller.movement_dir = direction
	collider.disabled = true


func _on_PlanetDetection_body_entered(_body: Node) -> void:
	movement_controller.movement_dir = Vector2.ZERO
	movement_controller.stop_movement()
	
	call_deferred("_enable_collision")
	
	gathering_component.planet_target = planet_target


func _enable_collision() -> void:
	collider.disabled = false


func set_resources_held(value: int) -> void:
	resources_held = value
	if resources_held >= MAX_RESOURCES:
		resources_full.show()
		gathering_component.disable_gathering()
