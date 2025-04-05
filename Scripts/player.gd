extends Node2D

@export var _character: CharacterBody2D
@onready var _game_manager: GameManager = $/root/Game

var _input_direction: Vector2
var _move_direction: Vector2

func _input(event: InputEvent):
	if get_tree().paused:
		_process_input_paused(event)
	else:
		_process_input_unpaused(event)

func _process_input_paused(event: InputEvent):
	if event.is_action_pressed("pause"):
		_game_manager.toggle_pause()

func _process_input_unpaused(event: InputEvent):
	if event.is_action_pressed("pause"):
		_game_manager.toggle_pause()
	if event.is_action_pressed("dig"):
		_character.dig()

func _process(_delta: float):
	if get_tree().paused:
		return

	_character.face_direction(get_global_mouse_position())
	_input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	_move_direction = _input_direction.normalized()
	_character.move(_move_direction)
