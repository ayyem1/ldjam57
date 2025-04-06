extends CharacterBody2D


const SPEED = 300.0

@export var _speed: float = 200
@export var _dig_threshold: float = 500
# This is multiplied by the dig threshold to determine if the player was close
@export var _closeness_multiplier: float = 2.5

@onready var _rig: Node2D = $Rig
@onready var _detector: Area2D = $Rig/Detector

var _direction: Vector2
var _remaining_energy: float
var _collected_coins: int

func reset(starting_energy: float):
	_remaining_energy = starting_energy
	_collected_coins = 0

func reduce_energy(amount: float):
	_remaining_energy -= amount
	EventBus.reduce_energy.emit(_remaining_energy)
	if _remaining_energy <= 0:
		EventBus.end_level.emit(false)

func face_direction(direction: Vector2):
	_rig.look_at(direction)

func move(direction: Vector2):
	_direction = direction

func dig(_energy_reduction: float):
	reduce_energy(_energy_reduction)
	if !_detector.active_item:
		print("Nothing to dig")
		return

	var dist = (_detector.active_item.global_position - _detector.global_position).length_squared()
	print(dist)
	if dist <= _dig_threshold:
		if _detector.active_item.is_dud:
			# Play some audio here
			print("Dud found")
		else:
			_collected_coins += _detector.active_item.value
			EventBus.acquire_item.emit(_detector.active_item, _collected_coins)
		_detector.destroy_active_item()
	elif dist <= _closeness_multiplier * _dig_threshold:
		print("Close")
	else:
		print("No Item found")
	
func _physics_process(_delta: float) -> void:
	if _direction:
		velocity = _direction * _speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
