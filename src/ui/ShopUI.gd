extends Control

signal item_purchased(item)

onready var buy_button = $ColorRect/VBoxContainer/HBoxContainer/BuyItemButton

onready var item_icon = $ColorRect/VBoxContainer/HBoxContainer/ItemIcon
onready var cost_label = $ColorRect/VBoxContainer/HBoxContainer/ItemCostLabel
onready var item_description = $ColorRect/VBoxContainer/HBoxContainer/ItemDescriptionLabel

var available_coin: int = 0

var shop_items: Array


func open(_available_coin: int, items: Array) -> void:
	shop_items = items
	var item = items[0] as ShopItem
	cost_label.text = str(item.item_cost)
	item_icon.texture = item.item_texture
	item_description.text = item.item_description
	
	show()
	available_coin = _available_coin
	if available_coin < int(cost_label.text):
		buy_button.disabled = true
	else:
		buy_button.disabled = false


func _on_CloseButton_pressed() -> void:
	hide()


func _on_BuyItemButton_pressed() -> void:
	var bought_item: ShopItem = shop_items[0]
	emit_signal("item_purchased", bought_item)
