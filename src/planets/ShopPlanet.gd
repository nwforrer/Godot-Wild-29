extends Planet


export(int) var CREDITS_REQUIREMENT = 5
export(Array, Resource) var shop_items

onready var offscreen_marker = $OffscreenMarker


func _ready() -> void:
	if not unlocked:
		offscreen_marker.disabled = true
	
	for item in shop_items:
		item = item as ShopItem
		if not item:
			print(str(item) + " is not a ShopItem resource.")


func get_requirement_dialog() -> String:
	return "Return with more credits."


func unlock() -> void:
	.unlock()
	offscreen_marker.disabled = false
