extends Node

onready var select_sound := $SelectSound

onready var typing_sounds := [$TypingSound2]


func play_typing_sound() -> void:
	for sound in typing_sounds:
		if sound.playing:
			return
	var index = rand_range(0, typing_sounds.size())
	typing_sounds[index].play()
