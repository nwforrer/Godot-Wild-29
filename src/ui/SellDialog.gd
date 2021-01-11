extends Control

signal resources_sold

onready var sell_label = $HBoxContainer/SellLabel


func display_sell_dialog(amount: int) -> void:
	sell_label.text = "Sell " + str(amount) + " resources?"
	show()


func _on_SellButton_pressed() -> void:
	emit_signal("resources_sold")
