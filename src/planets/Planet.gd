extends StaticBody2D
class_name Planet

signal planet_entered_screen(id)
signal planet_exited_screen(id)


enum PlanetType {
	RESOURCE,
	MERCHANT,
}
export(PlanetType) var PLANET_TYPE = PlanetType.RESOURCE


func _on_VisibilityNotifier2D_screen_entered() -> void:
	emit_signal("planet_entered_screen", self)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	emit_signal("planet_exited_screen", self)

