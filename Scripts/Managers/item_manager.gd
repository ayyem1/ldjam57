extends Node2D

@onready var items: Array[Node] = get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.start_level.connect(_reset_items)

func _reset_items(_start_pos: Vector2):
	for item in items:
		item.visible = true
		item.set_collision_layer_value(17, true)
