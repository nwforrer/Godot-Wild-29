extends Planet

signal resources_bought(planet)
signal resupplied(planet)

export(String) var MERCHANT_DIALOG

export(int) var RESOURCE_REQUEST_AMOUNT

onready var quest_marker = $QuestMarker
onready var offscreen_marker = $OffscreenMarker
onready var resupply_timer = $ResupplyTimer

var can_buy: bool = true


func _ready() -> void:
	if not unlocked:
		quest_marker.hide()
		offscreen_marker.disabled = true


func get_dialog() -> String:
	if can_buy:
		return "We will buy " + str(RESOURCE_REQUEST_AMOUNT) + " resources."
	else:
		return "We do not need any more resources."


func get_requested_amount() -> int:
	return RESOURCE_REQUEST_AMOUNT


func sell_resources() -> void:
	can_buy = false
	emit_signal("resources_bought", self)
	quest_marker.hide()
	offscreen_marker.disabled = true
	trigger_unlocks()
	resupply_timer.start()


func unlock() -> void:
	.unlock()
	quest_marker.show()
	offscreen_marker.disabled = false


func _on_ResupplyTimer_timeout() -> void:
	emit_signal("resupplied", self)
	can_buy = true
	quest_marker.show()
	offscreen_marker.disabled = false
