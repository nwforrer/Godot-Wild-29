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


func _on_credits_held_pirate_threshold(_credits_amount, player_ship) -> void:
	if randf() < 0.3:
		ai_controller.chase_player(player_ship)


func _on_InteractionArea_body_entered(body: Node) -> void:
	if ai_controller.ai_state == ai_controller.AiState.CHASE_PLAYER:
		return
	ai_controller.handle_planet_interaction(body)
	._on_InteractionArea_body_entered(body)

