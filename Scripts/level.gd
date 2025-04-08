class_name Level extends Node2D

@onready var items: Array[Node] = get_children()
@export var goal: int = 10
@export var start_text: String = ""

func reset_items(enabled: bool):
	for item in items:
		item.visible = false 
		item.set_collision_layer_value(17, enabled)