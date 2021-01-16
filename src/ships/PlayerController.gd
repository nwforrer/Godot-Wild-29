extends Node

signal launch_miner

export(NodePath) var MovementController
onready var movement_controller: MovementController = get_node(MovementController)


func _process(_delta: float) -> void:
	var movement_dir: Vector2
	movement_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	movement_dir = movement_dir.normalized()
	
	movement_controller.movement_dir = movement_dir
	
	if Input.is_action_just_pressed("launch_miner"):
		emit_signal("launch_miner")

