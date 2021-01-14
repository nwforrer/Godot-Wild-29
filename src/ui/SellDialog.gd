extends Control

signal resources_sold

onready var sell_label = $HBoxContainer/SellLabel

var resources_amount: int = 0


func display_sell_dialog(amount: int) -> void:
	resources_amount = amount
	sell_label.text = "Sell " + str(amount) + " resources?"
	show()


func _on_SellButton_pressed() -> void:
	emit_signal("resources_sold")
