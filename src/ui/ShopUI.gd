extends Control

signal item_purchased(item)

onready var item_list = $ColorRect/ItemList

var available_coin: int = 0

var shop_items: Array


func open(_available_coin: int, items: Array) -> void:
	available_coin = _available_coin
	shop_items = items
	
	if item_list.get_child_count() > 0:
		for i in range(0, item_list.get_child_count()):
			item_list.get_child(i).queue_free()
	
	generate_item_list()
	show()


func generate_item_list() -> void:
	for item in shop_items:
		item = item as ShopItem
		if item:
			var container = HBoxContainer.new()
			item_list.add_child(container)
			
			var buy_button = Button.new()
			buy_button.text = "Buy"
			buy_button.rect_min_size.x = 35
			if available_coin < item.item_cost:
				buy_button.disabled = true
			buy_button.connect("pressed", self, "_on_BuyItemButton_pressed", [buy_button, item])
			container.add_child(buy_button)
			
			var cost_label = Label.new()
			cost_label.text = str(item.item_cost)
			container.add_child(cost_label)
			
			var item_icon = TextureRect.new()
			item_icon.texture = item.item_texture
			item_icon.size_flags_vertical = SIZE_SHRINK_CENTER
			container.add_child(item_icon)
			
			var item_description = Label.new()
			item_description.text = item.item_description
			item_description.rect_min_size.x = 215
			item_description.autowrap = true
			container.add_child(item_description)


func _on_CloseButton_pressed() -> void:
	SoundEffects.select_sound.play()
	hide()


func _on_BuyItemButton_pressed(button: Button, bought_item: ShopItem) -> void:
	SoundEffects.select_sound.play()
	available_coin -= bought_item.item_cost
	if available_coin < bought_item.item_cost:
		button.disabled = true
	emit_signal("item_purchased", bought_item)
