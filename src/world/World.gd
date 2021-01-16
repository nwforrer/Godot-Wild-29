extends Node2D

export(Array, PackedScene) var Levels

export(int) var credits_held_pirate_threshold: int = 10

onready var camera = $Camera2D
onready var gui = $GUI
onready var resource_ui = $GUI/ResourceUI
onready var quest_dialog_ui = $GUI/QuestDialog
onready var sell_dialog_ui = $GUI/SellDialog
onready var shop_ui = $GUI/ShopUI
onready var next_level_ui = $GUI/NextLevelScreen
onready var player_ship = $Spaceship

var NotificationPopup = preload("res://src/ui/NotificationPopup.tscn")

var current_level_index: int = 0
var current_level: Node2D

var remaining_merchant_planets: Array
var remaining_resource_planets: Array
var remaining_shop_planets: Array


func _ready() -> void:
	VisualServer.set_default_clear_color(Color("272744"))
	
	_load_level(current_level_index)
	
	resource_ui.show_miners_container(player_ship.miners_unlocked)
	resource_ui.update_num_miners(player_ship.num_miners)
	
	#var master_bus_idx = AudioServer.get_bus_index("Master")
	#AudioServer.set_bus_volume_db(master_bus_idx, -30)


func _load_level(index: int) -> void:
	if index >= Levels.size():
		print("Invalid level index: " + str(index))
		return
	if current_level:
		for planet in current_level.get_node("Planets").get_children():
			planet.disconnect("planet_entered_screen", self, "_planet_entered_screen")
			planet.disconnect("planet_exited_screen", self, "_planet_exited_screen")
			if planet.PLANET_TYPE == Planet.PlanetType.MERCHANT:
				planet.disconnect("resources_bought", self, "_planet_resources_bought")
			elif planet.PLANET_TYPE == Planet.PlanetType.RESOURCE:
				planet.disconnect("resources_exhausted", self, "_planet_resources_exhausted")
		
		current_level.queue_free()
		camera.clear_visible_planets()
	
	remaining_merchant_planets.clear()
	remaining_resource_planets.clear()
	remaining_shop_planets.clear()
	
	player_ship.stop_moving_immediately()
	player_ship.global_position = Vector2.ZERO
	
	for miner in get_tree().get_nodes_in_group("miner"):
		miner.queue_free()
	
	var next_level = Levels[index]
	current_level = next_level.instance()
	add_child(current_level)
	for planet in current_level.get_node("Planets").get_children():
		planet.connect("planet_entered_screen", self, "_planet_entered_screen")
		planet.connect("planet_exited_screen", self, "_planet_exited_screen")
		
		match planet.PLANET_TYPE:
			Planet.PlanetType.MERCHANT:
				planet.connect("resources_bought", self, "_planet_resources_bought")
				remaining_merchant_planets.append(planet)
			Planet.PlanetType.RESOURCE:
				planet.connect("resources_exhausted", self, "_planet_resources_exhausted")
				remaining_resource_planets.append(planet)
			Planet.PlanetType.SHOP:
				remaining_shop_planets.append(planet)


func _level_complete() -> void:
	if current_level_index + 1 >= Levels.size():
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://src/ui/GameOverScreen.tscn")
	next_level_ui.show()
	#get_tree().paused = true


func _planet_entered_screen(planet):
	camera.add_visible_planet(planet)


func _planet_exited_screen(planet):
	camera.remove_visible_planet(planet)


func _planet_resources_bought(planet):
	remaining_merchant_planets.erase(planet)
	if remaining_merchant_planets.size() == 0:
		_level_complete()


func _planet_resources_exhausted(planet):
	remaining_resource_planets.erase(planet)
	if remaining_resource_planets.size() == 0:
		var required_resources : int = 0
		for merchant_planet in remaining_merchant_planets:
			required_resources += merchant_planet.RESOURCE_REQUEST_AMOUNT
		if required_resources > player_ship.resources_held:
			print("level failed")
			#_level_complete()


func _on_Spaceship_update_resources(value) -> void:
	resource_ui.update_num_resources(value)


func _on_Camera2D_camera_zoom_updated(zoom_amount) -> void:
	if player_ship:
		player_ship.camera_zoom_updated(zoom_amount)


func _on_Spaceship_show_dialog(text) -> void:
	quest_dialog_ui.display_dialog(text)


func _on_Spaceship_remove_dialog() -> void:
	quest_dialog_ui.hide()
	sell_dialog_ui.hide()
	shop_ui.hide()


func _on_SellDialog_resources_sold() -> void:
	sell_dialog_ui.hide()
	player_ship.sell_resources()


func _on_Spaceship_show_sell_dialog(amount) -> void:
	sell_dialog_ui.display_sell_dialog(amount)


func _on_NextLevelButton_pressed() -> void:
	get_tree().paused = false
	next_level_ui.hide()
	current_level_index += 1
	if current_level_index < Levels.size():
		_load_level(current_level_index)


func _on_Spaceship_update_miner_count(value) -> void:
	resource_ui.update_num_miners(value)


func _on_Spaceship_update_credits(old_value, value) -> void:
	resource_ui.update_credits(value)
	for planet in remaining_shop_planets:
		if planet.unlocked and value >= planet.min_cost:
			planet.show_notification(true)
		else:
			planet.show_notification(false)
	
	if value >= credits_held_pirate_threshold and old_value < credits_held_pirate_threshold:
		WorldEvents.emit_signal("credits_held_pirate_threshold", player_ship.credits_held, player_ship)
		var notification_popup = NotificationPopup.instance()
		gui.add_child(notification_popup)
		notification_popup.display_notification("Nearby competitors alerted to your riches!")


func _on_Spaceship_show_shop(num_credits, shop_planet) -> void:
	shop_ui.open(num_credits, shop_planet.shop_items)


func _on_ShopUI_item_purchased(item: ShopItem) -> void:
	if player_ship.credits_held >= item.item_cost:
		player_ship.credits_held -= item.item_cost
		if item.item_type == ShopItem.ItemType.MINER:
			player_ship.num_miners += 1
			if not player_ship.miners_unlocked:
				player_ship.miners_unlocked = true
				resource_ui.show_miners_container(true)
				if item.tutorial_scene_path:
					print(item.tutorial_scene_path)
					var tutorial_ui = item.tutorial_scene_path.instance()
					gui.add_child(tutorial_ui)
					get_tree().paused = true

