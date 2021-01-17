extends Node

onready var music = $Music

export(Array, AudioStream) var soundtrack = []

var soundtrack_index := 0

func _ready() -> void:
	_play_next_song()

func _play_next_song():
	music.stream = soundtrack[soundtrack_index]
	music.play()
	soundtrack_index = (soundtrack_index + 1) % soundtrack.size()

func _on_Music_finished() -> void:
	_play_next_song()
