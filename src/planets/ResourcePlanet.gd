extends Planet

signal resources_exhausted(planet)

export(int) var MAX_RESOURCES = 10
onready var remaining_resources: int = MAX_RESOURCES setget set_remaining_resources

onready var regenerate_timer: Timer = $RegenerateTimer

var can_regenerate: bool = true

func can_consume() -> bool:
	return can_regenerate


func consume_resource() -> void:
	self.remaining_resources -= 1


func _on_RegenerateTimer_timeout() -> void:
	self.remaining_resources += 1


func set_remaining_resources(value: int) -> void:
	remaining_resources = clamp(value, 0, MAX_RESOURCES) as int
	if remaining_resources == 0 and can_regenerate:
		regenerate_timer.stop()
		can_regenerate = false
		modulate = Color.red
		emit_signal("resources_exhausted", self)
