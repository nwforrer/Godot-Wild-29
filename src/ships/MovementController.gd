extends Node
class_name MovementController

export(float) var ACCELERATION = 100.0
export(float) var MAX_SPEED = 100.0

export(NodePath) var Target
onready var target: KinematicBody2D = get_node(Target)

var velocity: Vector2
var movement_dir: Vector2


func _physics_process(delta: float) -> void:
	velocity += movement_dir * ACCELERATION * delta
	velocity = velocity.clamped(MAX_SPEED)
	velocity = target.move_and_slide(velocity)


func is_accelerating() -> bool:
	return movement_dir.length() > 0


func stop_movement() -> void:
	velocity = Vector2.ZERO
