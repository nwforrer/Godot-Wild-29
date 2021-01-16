extends Planet


export(Array, Resource) var shop_items

onready var offscreen_marker = $OffscreenMarker
onready var quest_marker = $QuestMarker

var min_cost: int = 9999


func _ready() -> void:
	if not unlocked:
		offscreen_marker.disabled = true
	
	for item in shop_items:
		item = item as ShopItem
		if not item:
			print(str(item) + " is not a ShopItem resource.")
		else:
			if item.item_cost < min_cost:
				min_cost = item.item_cost


func get_requirement_dialog() -> String:
	return "Return with more credits."


func show_notification(show: bool) -> void:
	if show and unlocked:
		quest_marker.show()
	else:
		quest_marker.hide()


func unlock() -> void:
	.unlock()
	offscreen_marker.disabled = false
