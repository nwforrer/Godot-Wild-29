extends "res://src/ships/Spaceship.gd"

signal update_resources(value)
signal update_credits(old_value, value)
signal show_dialog(text)
signal remove_dialog()
signal show_sell_dialog(amount)
signal show_shop(num_credits, shop_planet)

var credits_held: int = 0 setget set_credits_held

func _process(_delta: float) -> void:
	if planet_target and not movement_controller.is_accelerating():
		movement_controller.stop_movement()
	
	update()


func sell_resources() -> void:
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.MERCHANT:
		resources_held -= planet_target.get_requested_amount()
		planet_target.sell_resources()
		emit_signal("update_resources", resources_held)
		self.credits_held += planet_target.get_requested_amount()


func _draw() -> void:
	if planet_target and planet_target.PLANET_TYPE == Planet.PlanetType.RESOURCE and planet_target.can_regenerate:
		draw_line(global_position - global_position, planet_target.global_position - global_position, Color("fbf5ef"), 5.0)


func set_planet_target(planet: Planet) -> void:
	if planet:
		match planet.PLANET_TYPE:
			Planet.PlanetType.MERCHANT:
				if planet.can_buy and resources_held >= planet.get_requested_amount():
					emit_signal("show_sell_dialog", planet.get_requested_amount())
				else:
					emit_signal("show_dialog", planet.get_dialog())
			
			Planet.PlanetType.SHOP:
				emit_signal("show_shop", credits_held, planet)
	else:
		emit_signal("remove_dialog")
	
	.set_planet_target(planet)


func set_resources_held(value: int) -> void:
	.set_resources_held(value)
	emit_signal("update_resources", resources_held)


func set_credits_held(value: int) -> void:
	emit_signal("update_credits", credits_held, value)
	credits_held = value


func _on_PlayerController_launch_miner() -> void:
	_launch_miner()


func consume_credit() -> void:
	if credits_held > 0:
		self.credits_held -= 1
