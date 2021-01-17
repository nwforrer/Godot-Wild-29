extends Control

onready var typing_timer = $TypingTimer
onready var dialog = $RichTextLabel


func _ready() -> void:
	dialog.visible_characters = 0


func _on_TypingTimer_timeout() -> void:
	dialog.visible_characters += 1
	if dialog.visible_characters % 2 == 0:
		SoundEffects.play_typing_sound()
	
	if dialog.visible_characters == dialog.get_total_character_count():
		typing_timer.stop()


func _on_Button_pressed() -> void:
	SoundEffects.select_sound.play()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/world/World.tscn")
