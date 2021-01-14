extends Control

signal purchase_miner(cost)

onready var miner_buy_button = $ColorRect/VBoxContainer/HBoxContainer/BuyMinerButton
onready var miner_cost_label = $ColorRect/VBoxContainer/HBoxContainer/MinerCostLabel

var available_coin: int = 0


func open(_available_coin: int) -> void:
	show()
	available_coin = _available_coin
	if available_coin < int(miner_cost_label.text):
		miner_buy_button.disabled = true
	else:
		miner_buy_button.disabled = false


func _on_BuyMinerButton_pressed() -> void:
	emit_signal("purchase_miner", int(miner_cost_label.text))


func _on_CloseButton_pressed() -> void:
	hide()
