extends Planet


export(int) var CREDITS_REQUIREMENT = 5

onready var offscreen_marker = $OffscreenMarker


func _ready() -> void:
	if not unlocked:
		offscreen_marker.disabled = true


func get_requirement_dialog() -> String:
	return "Return with more credits."


func unlock() -> void:
	.unlock()
	offscreen_marker.disabled = false
