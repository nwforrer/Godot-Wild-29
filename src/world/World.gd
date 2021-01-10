extends Node2D

onready var planets = $Planets
onready var camera = $Camera2D
onready var resource_ui = $GUI/ResourceUI


func _ready() -> void:
	VisualServer.set_default_clear_color(Color.black)
	
	for planet in planets.get_children():
		planet.connect("planet_entered_screen", self, "_planet_entered_screen")
		planet.connect("planet_exited_screen", self, "_planet_exited_screen")


func _planet_entered_screen(planet):
	camera.add_visible_planet(planet)


func _planet_exited_screen(planet):
	camera.remove_visible_planet(planet)



func _on_Spaceship_update_resources(value) -> void:
	resource_ui.update_num_resources(value)
