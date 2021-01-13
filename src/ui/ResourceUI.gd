extends Control

onready var resource_label = $VBoxContainer/HBoxContainer/ResourceAmount
onready var miner_count = $VBoxContainer/HBoxContainer2/MinerCount


func update_num_resources(value: int) -> void:
	resource_label.text = str(value)


func update_num_miners(value: int) -> void:
	miner_count.text = str(value)
