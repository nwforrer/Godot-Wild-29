extends Control

onready var dialog_text_label = $CenterContainer/DialogText
onready var typing_timer = $TypingTimer


func display_dialog(text: String) -> void:
	dialog_text_label.text = text
	dialog_text_label.percent_visible = 0
	show()
	typing_timer.start()


func _on_TypingTimer_timeout() -> void:
	if dialog_text_label.percent_visible != 1:
		dialog_text_label.percent_visible += .1
		typing_timer.start()
