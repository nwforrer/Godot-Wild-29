extends KinematicBody2D
class_name Miner

export(int) var MAX_RESOURCES = 5

onready var movement_controller = $MovementController
onready var gathering_component = $GatheringComponent
onready var resources_full = $ResourcesFullIndicator
onready var collider = $CollisionShape2D
onready var offscreen_marker = $OffscreenMarker

var planet_target: Planet = null
var resources_held: int = 0 setget set_resources_held
var job_complete: bool = false setget set_job_complete
var owning_ship: Node = null


func launch(owner: Node, target: Planet) -> void:
	owning_ship = owner
	planet_target = target
	var direction = (target.global_position - global_position).normalized()
	global_rotation = direction.angle() - deg2rad(90)
	movement_controller.movement_dir = direction
	collider.disabled = true
	offscreen_marker.disabled = true
	
	# warning-ignore:return_value_discarded
	planet_target.connect("resources_exhausted", self, "_on_planet_target_resources_exhausted")


func set_job_complete(value: bool) -> void:
	job_complete = value
	if job_complete:
		resources_full.show()
		gathering_component.disable_gathering()
		offscreen_marker.disabled = false
	else:
		resources_full.hide()


func _on_PlanetDetection_body_entered(_body: Node) -> void:
	movement_controller.movement_dir = Vector2.ZERO
	movement_controller.stop_movement()
	
	call_deferred("_enable_collision")
	
	gathering_component.planet_target = planet_target


func _on_planet_target_resources_exhausted(_planet):
	self.job_complete = true


func _enable_collision() -> void:
	collider.disabled = false


func set_resources_held(value: int) -> void:
	resources_held = value
	if resources_held >= MAX_RESOURCES:
		self.job_complete = true
