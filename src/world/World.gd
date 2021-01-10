extends Node2D

onready var planets = $Planets
onready var camera = $Camera2D
onready var resource_ui = $GUI/ResourceUI
onready var quest_dialog_ui = $GUI/QuestDialog
onready var sell_dialog_ui = $GUI/SellDialog
onready var player_ship = $Spaceship


func _ready() -> void:
	VisualServer.set_default_clear_color(Color("272744"))
	
	for planet in planets.get_children():
		planet.connect("planet_entered_screen", self, "_planet_entered_screen")
		planet.connect("planet_exited_screen", self, "_planet_exited_screen")


func _planet_entered_screen(planet):
	camera.add_visible_planet(planet)


func _planet_exited_screen(planet):
	camera.remove_visible_planet(planet)



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


func _on_SellDialog_resources_sold() -> void:
	sell_dialog_ui.hide()
	player_ship.sell_resources()


func _on_Spaceship_show_sell_dialog(amount) -> void:
	sell_dialog_ui.display_sell_dialog(amount)
