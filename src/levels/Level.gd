extends Node2D

onready var enemy_ships = $EnemyShips
onready var planets = $Planets


func _ready() -> void:
	for enemy in enemy_ships.get_children():
		for planet in planets.get_children():
			if planet.PLANET_TYPE == Planet.PlanetType.RESOURCE:
				enemy.get_node("AIController").add_resource_planet(planet)
		enemy.get_node("AIController").start_ai()
