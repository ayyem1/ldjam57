extends Node2D

@export var _character: CharacterBody2D
@onready var _game_manager: GameManager = $/root/Game

@export var _character_starting_energy: float = 100
@export var _energy_reduction_per_second: float = 1
@export var _dig_energy_reduction: float = 5

var _input_direction: Vector2
var _move_direction: Vector2

func _ready() -> void:
	EventBus.reset_level.connect(_reset)
	EventBus.start_level.connect(_on_level_start)


func _reset(player_start: Vector2, goal: int):
	_character.global_position = player_start
	_character.reset(_character_starting_energy, goal)
	EventBus.reset_character_energy.emit(_character_starting_energy)

func _on_level_start(current_level: Level):
	_character.display_text(current_level.start_text, 2)

func _input(event: InputEvent):
	if !_game_manager.is_game_active:
		return

	if get_tree().paused:
		_process_input_paused(event)
	else:
		_process_input_unpaused(event)

func _process_input_paused(event: InputEvent):
	if event.is_action_pressed("pause"):
		EventBus.toggle_pause.emit()

func _process_input_unpaused(event: InputEvent):
	if event.is_action_pressed("pause"):
		EventBus.toggle_pause.emit()
	if event.is_action_pressed("dig"):
		_character.dig(_dig_energy_reduction)

func _process(delta: float):
	if !_game_manager.is_game_active || _character.is_digging:
		_character.stop_movement()
		return

	if get_tree().paused:
		return
	
	# NOTE: Disabled constant energy deduction.
	# _character.reduce_energy(_energy_reduction_per_second * delta, false)
	_character.face_direction(get_global_mouse_position())
	_input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	_move_direction = _input_direction.normalized()
	_character.move(_move_direction)