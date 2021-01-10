extends KinematicBody2D

signal update_resources(value)

onready var movement_controller = $MovementController
onready var gathering_timer: Timer = $GatheringTimer

var resources_held: int = 0 setget set_resources_held
var gathering_target: Planet = null


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if gathering_target:
		draw_line(global_position - global_position, gathering_target.global_position - global_position, Color.yellow, 5.0)


func _on_InteractionArea_body_entered(body: Node) -> void:
	if gathering_target:
		return
		
	var planet = body as Planet
	if planet:
		print("gathering resources from: " + str(body))
		gathering_target = planet
		if not movement_controller.is_accelerating():
			movement_controller.stop_movement()


func _on_InteractionArea_body_exited(body: Node) -> void:
	if gathering_target and gathering_target == body:
		gathering_target = null
		print("stopped gathering from " + str(body))


func _on_GatheringTimer_timeout() -> void:
	if gathering_target != null and gathering_target.can_consume():
		gathering_target.consume_resource()
		self.resources_held += 1

func set_resources_held(value: int) -> void:
	resources_held = value
	emit_signal("update_resources", resources_held)
