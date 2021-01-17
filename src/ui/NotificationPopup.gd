extends Popup

onready var notification_text = $NotificationText
onready var notification_timer = $NotificationTimer
onready var typing_timer = $TypingTimer


func display_notification(text: String) -> void:
	notification_text.bbcode_text = "[center]" + text + "[/center]"
	notification_text.visible_characters = 0
	call_deferred("popup")
	notification_timer.start()
	typing_timer.start()


func _on_NotificationTimer_timeout() -> void:
	queue_free()


func _on_TypingTimer_timeout() -> void:
	notification_text.visible_characters += 1
	if notification_text.visible_characters % 2 == 0:
		SoundEffects.play_typing_sound()
	
	if notification_text.visible_characters == notification_text.get_total_character_count():
		typing_timer.stop()
