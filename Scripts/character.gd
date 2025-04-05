extends CharacterBody2D


const SPEED = 300.0

@export var _speed: float = 200
@export var _rotation_speed: float = PI * 2

var _direction: Vector2

func move(direction: Vector2):
	_direction = direction

func _physics_process(_delta: float) -> void:
	if _direction:
		velocity = _direction * _speed 
	else:
		velocity = Vector2.ZERO

	move_and_slide()
