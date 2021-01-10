extends Control

onready var resource_label = $HBoxContainer/ResourceAmount

var num_resources: int = 0


func update_num_resources(value: int) -> void:
	resource_label.text = str(value)
