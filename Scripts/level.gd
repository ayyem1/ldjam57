extends Node3D

@onready var _transitions: Array[Node] = $Transitions.get_children()

func _ready() -> void:
	for i in len(_transitions):
		_transitions[i].id = i

func get_entrance_position(transition_index: int) -> Vector3:
	return _transitions[transition_index].entrance.global_position

func get_entrance_forward(transition_index: int) -> float:
	return _transitions[transition_index].rotation.y

func activate_transitions():
	for transition in _transitions:
		transition.monitoring = true
