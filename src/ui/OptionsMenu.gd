extends Control

onready var master_slider := $CenterContainer/VBoxContainer/MasterVolumeContainer/MasterVolumeSlider
onready var music_slider := $CenterContainer/VBoxContainer/MusicVolumeContainer/MusicVolumeSlider
onready var effects_slider := $CenterContainer/VBoxContainer/SoundEffectsVolumeContainer/EffectsVolumeSlider


func _ready() -> void:
	master_slider.value = _get_bus_volume("Master")
	music_slider.value = _get_bus_volume("Music")
	effects_slider.value = _get_bus_volume("Sound")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		SceneUtils.goto_previous_scene()
		get_tree().set_input_as_handled()


func _on_MasterVolumeSlider_value_changed(value: float) -> void:
	_change_bus_volume("Master", value)


func _on_BackButton_pressed() -> void:
	SoundEffects.select_sound.play()
	SceneUtils.goto_previous_scene()


func _on_MusicVolumeSlider_value_changed(value: float) -> void:
	_change_bus_volume("Music", value)


func _on_EffectsVolumeSlider_value_changed(value: float) -> void:
	_change_bus_volume("Sound", value)


func _change_bus_volume(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, value)


func _get_bus_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_db(bus_index)
