extends Control

onready var enemy := $EnemyShip
onready var planets := $Planets

func _ready() -> void:
	VisualServer.set_default_clear_color(Color("272744"))
	
	for planet in planets.get_children():
		if planet.PLANET_TYPE == Planet.PlanetType.RESOURCE:
			enemy.get_node("AIController").add_resource_planet(planet)
	enemy.start_ai()


func _on_StartButton_pressed() -> void:
	SoundEffects.select_sound.play()
	SceneUtils.change_scene("res://src/ui/IntroDialog.tscn")


func _on_QuitButton_pressed() -> void:
	SoundEffects.select_sound.play()
	get_tree().quit()


func _on_OptionsButton_pressed() -> void:
	SoundEffects.select_sound.play()
	SceneUtils.change_scene("res://src/ui/OptionsMenu.tscn")
