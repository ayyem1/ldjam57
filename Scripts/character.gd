extends CharacterBody2D

@export var _speed: float = 200
@export var _dig_threshold: float = 500
# This is multiplied by the dig threshold to determine if the player was close
@export var _closeness_multiplier: float = 2.5

@onready var _rig: Node2D = $Rig
@onready var _detector: Area2D = $Rig/Detector

@onready var _dig_stream: AudioStreamPlayer = $DigASP
@onready var _no_item_stream: AudioStreamPlayer = $NoItemASP
@onready var _dud_item_stream: AudioStreamPlayer = $DudPickupASP
@onready var _close_item_stream: AudioStreamPlayer = $CloseToItemASP
@onready var _small_item_stream: AudioStreamPlayer = $SmallPickupASP
@onready var _medium_item_stream: AudioStreamPlayer = $MediumPickupASP
@onready var _large_item_stream: AudioStreamPlayer = $LargePickupASP

@onready var _textbox: MarginContainer = $Textbox
@onready var _textbox_label: Label = $Textbox/MarginContainer/Label

var _direction: Vector2
var _remaining_energy: float
var _collected_coins: int
var _level_goal: int

var is_digging: bool = false

func reset(starting_energy: float, goal: int):
	_remaining_energy = starting_energy
	_level_goal = goal
	_collected_coins = 0

func reduce_energy(amount: float, is_dig: bool):
	var prev_energy = _remaining_energy
	_remaining_energy -= amount
	EventBus.reduce_energy.emit(prev_energy, _remaining_energy, is_dig)
	if _remaining_energy <= 0:
		EventBus.end_level.emit(false)

func face_direction(direction: Vector2):
	_rig.look_at(direction)

func stop_movement():
	_direction = Vector2.ZERO

func move(direction: Vector2):
	_direction = direction

func dig(_energy_reduction: float):
	is_digging = true
	reduce_energy(_energy_reduction, true)
	_dig_stream.play()
	await _dig_stream.finished
	await get_tree().create_timer(.05).timeout # TODO: Does this make the game worse?

	if !_detector.active_item:
		_display_text("Nothing detected.")
		_no_item_stream.play()
		await _no_item_stream.finished
		is_digging = false
		return

	var dist = (_detector.active_item.global_position - _detector.global_position).length_squared()
	print(dist)
	if dist <= _dig_threshold:
		if _detector.active_item.is_dud:
			_display_text("Garbage.")
			_dud_item_stream.play()
			# TODO: Show VFX
			await _dud_item_stream.finished
		else:
			_display_text(_detector.active_item.display_text)
			if _detector.active_item.value >= 8:
				_large_item_stream.play()
				await _large_item_stream.finished
			elif _detector.active_item.value >= 3:
				_medium_item_stream.play()
				await _medium_item_stream.finished
			else:
				_small_item_stream.play()
				await _small_item_stream.finished
			_collected_coins += _detector.active_item.value
			EventBus.acquire_item.emit(_detector.active_item, _collected_coins, _level_goal)
		_detector.disable_active_item()
	elif dist <= _closeness_multiplier * _dig_threshold:
		_display_text("I'm close!")
		_close_item_stream.play()
		await _close_item_stream.finished
	else:
		_display_text("I'm too far.")
		_no_item_stream.play()
		await _no_item_stream.finished

	is_digging = false
	
func _display_text(text: String, duration: float = 1.5):
	_textbox_label.text = text
	_textbox.visible = true
	await get_tree().create_timer(duration).timeout
	_textbox.visible = false
	
func _physics_process(_delta: float) -> void:
	if _direction:
		velocity = _direction * _speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
