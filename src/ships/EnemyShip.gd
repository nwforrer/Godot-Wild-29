extends "res://src/ships/Spaceship.gd"


export(bool) var is_active = true setget set_is_active

onready var ai_controller = $AIController


func start_ai():
	if is_active:
		ai_controller.start_ai()

func unlock():
	self.is_active = true


func set_is_active(value: bool) -> void:
	is_active = value
	if is_active:
		ai_controller.start_ai()
