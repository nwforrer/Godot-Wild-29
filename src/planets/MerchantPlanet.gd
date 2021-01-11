extends Planet

signal resources_bought(planet)

export(String) var MERCHANT_DIALOG

export(int) var RESOURCE_REQUEST_AMOUNT

onready var quest_marker = $QuestMarker

var can_buy: bool = true


func get_dialog() -> String:
	if can_buy:
		return "We request " + str(RESOURCE_REQUEST_AMOUNT) + " resources."
	else:
		return "We do not need any more resources."


func get_requested_amount() -> int:
	return RESOURCE_REQUEST_AMOUNT


func sell_resources() -> void:
	can_buy = false
	emit_signal("resources_bought", self)
	quest_marker.hide()
