extends Node
class_name MovementController

export(float) var ACCELERATION = 100.0
export(float) var CLOSE_MAX_SPEED = 75.0
export(float) var FAR_MAX_SPEED = 150.0

export(NodePath) var Target
onready var target: KinematicBody2D = get_node(Target)

var max_speed: float = CLOSE_MAX_SPEED
var velocity: Vector2
var movement_dir: Vector2

var _decelerating_initial_velocity: Vector2
var _decelerating: bool = false


func _process(_delta: float) -> void:
	if _decelerating and not is_accelerating():
		velocity = velocity.linear_interpolate(Vector2.ZERO, .1)
	elif is_accelerating():
		_decelerating = false


func _physics_process(delta: float) -> void:
	velocity += movement_dir * ACCELERATION * delta
	velocity = velocity.clamped(max_speed)
	velocity = target.move_and_slide(velocity)


func is_accelerating() -> bool:
	return movement_dir.length() > 0


func stop_movement() -> void:
	if not _decelerating:
		_decelerating = true
		_decelerating_initial_velocity = velocity
