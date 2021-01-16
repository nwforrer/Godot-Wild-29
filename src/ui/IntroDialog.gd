extends Control


onready var dialog = $RichTextLabel


func _ready() -> void:
	dialog.percent_visible = 0


func _on_TypingTimer_timeout() -> void:
	dialog.percent_visible += .01


func _on_Button_pressed() -> void:
	SoundEffects.select_sound.play()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/world/World.tscn")
