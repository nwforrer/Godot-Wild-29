extends StaticBody2D
class_name Planet

signal planet_entered_screen(id)
signal planet_exited_screen(id)


enum PlanetType {
	RESOURCE,
	MERCHANT,
	SHOP,
}
export(PlanetType) var PLANET_TYPE = PlanetType.RESOURCE

export(bool) var unlocked = true

export(Array, NodePath) var unlocks_objects


func _on_VisibilityNotifier2D_screen_entered() -> void:
	emit_signal("planet_entered_screen", self)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	emit_signal("planet_exited_screen", self)


func unlock() -> void:
	unlocked = true


func trigger_unlocks() -> void:
	if unlocks_objects.size() > 0:
		for object in unlocks_objects:
			var o = get_node(object)
			if o:
				if o.has_method("unlock"):
					o.unlock()
				else:
					print(str(o) + " is missing unlock method.")
