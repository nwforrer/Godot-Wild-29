extends Planet

signal resources_exhausted(planet)

export(int) var MAX_RESOURCES = 10
onready var remaining_resources: int = MAX_RESOURCES setget set_remaining_resources

onready var exhausted_sound := $ResourcesExhaustedSound
onready var exhausted_effect := $ExhaustedEffect
onready var regenerate_timer: Timer = $RegenerateTimer
onready var sprite := $Sprite
onready var original_color_modulate: Color = sprite.modulate

var can_regenerate: bool = true

func can_consume() -> bool:
	return can_regenerate


func consume_resource() -> void:
	self.remaining_resources -= 1


func _on_RegenerateTimer_timeout() -> void:
	self.remaining_resources += 1


func set_remaining_resources(value: int) -> void:
	remaining_resources = clamp(value, 0, MAX_RESOURCES) as int
	sprite.modulate = Color.red.linear_interpolate(original_color_modulate, (remaining_resources as float) / MAX_RESOURCES)
	if remaining_resources == 0 and can_regenerate:
		sprite.modulate = Color("#260303")
		exhausted_sound.play()
		exhausted_effect.emitting = true
		regenerate_timer.stop()
		can_regenerate = false
		emit_signal("resources_exhausted", self)
