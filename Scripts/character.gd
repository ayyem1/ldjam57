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

var _direction: Vector2
var _remaining_energy: float
var _collected_coins: int

var is_digging: bool = false

func reset(starting_energy: float):
	_remaining_energy = starting_energy
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
	# Play shovel digging noise
	_dig_stream.play()
	await _dig_stream.finished
	await get_tree().create_timer(.05).timeout #TODO: Does this make the game worse?

	if !_detector.active_item:
		print("Nothing to dig")
		_no_item_stream.play()
		await _no_item_stream.finished
		is_digging = false
		return

	var dist = (_detector.active_item.global_position - _detector.global_position).length_squared()
	print(dist)
	if dist <= _dig_threshold:
		if _detector.active_item.is_dud:
			print("Dud found")
			_no_item_stream.play()
			# TODO: Show VFX
			await _no_item_stream.finished
		else:
			# TODO: Show VFX
			if _detector.active_item.value >= 8:
				_large_item_stream.play()
				await _large_item_stream.finished	
			elif _detector.active_item.value >= 3:
				_medium_item_stream.play()
				await  _medium_item_stream.finished
			else:
				_small_item_stream.play()
				await _small_item_stream.finished
			_collected_coins += _detector.active_item.value
			EventBus.acquire_item.emit(_detector.active_item, _collected_coins)
		_detector.destroy_active_item()
	elif dist <= _closeness_multiplier * _dig_threshold:
		print("Close")
		_close_item_stream.play()
		# TODO: Show VFX
		await _close_item_stream.finished
	else:
		print("No Item found")
		_no_item_stream.play()
		await _no_item_stream.finished
	print("leaving function")	
	is_digging = false
	

func _handle_dig_effects():
	# Determine what was found
	# Play correct sfx
	# Display correct vfx
	pass
	
func _physics_process(_delta: float) -> void:
	if _direction:
		velocity = _direction * _speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
