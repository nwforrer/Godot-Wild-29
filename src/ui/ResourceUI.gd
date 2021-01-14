extends Control

onready var resource_label = $HBoxContainer/VBoxContainer/HBoxContainer/ResourceAmount
onready var miners_container = $HBoxContainer/VBoxContainer/MinersContainer
onready var miner_count = $HBoxContainer/VBoxContainer/MinersContainer/MinerCount
onready var credits_amount = $HBoxContainer/HBoxContainer/CreditAmount


func update_num_resources(value: int) -> void:
	resource_label.text = str(value)


func update_credits(value: int) -> void:
	credits_amount.text = str(value)


func update_num_miners(value: int) -> void:
	miner_count.text = str(value)


func show_miners_container(should_show: bool) -> void:
	if should_show:
		miners_container.show()
	else:
		miners_container.hide()
