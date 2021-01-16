extends Popup

onready var notification_text = $NotificationText
onready var notification_timer = $NotificationTimer
onready var typing_timer = $TypingTimer


func display_notification(text: String) -> void:
	notification_text.bbcode_text = "[center]" + text + "[/center]"
	notification_text.percent_visible = 0
	call_deferred("popup")
	notification_timer.start()
	typing_timer.start()


func _on_NotificationTimer_timeout() -> void:
	queue_free()


func _on_TypingTimer_timeout() -> void:
	notification_text.percent_visible += 0.1
