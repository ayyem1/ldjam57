class_name CreditsManager extends SceneManager

# Pixels per second
@export var _slow_speed: float = 32
# Pixels per second
@export var _fast_speed: float = 512

# Pixels per second
@onready var _scroll_speed: float = _slow_speed
@onready var _scroll: VBoxContainer = $Scroll
@onready var _scroll_size: float = - _scroll.size.y + DisplayServer.window_get_size().y

func to_title_scene():
	change_scene("res://Scenes/title.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if _scroll.position.y <= _scroll_size:
			to_title_scene()
		else:
			_scroll_speed = _fast_speed
	elif event.is_action_released("jump"):
		_scroll_speed = _slow_speed

func _process(delta: float) -> void:
	if _scroll.position.y <= _scroll_size:
		_scroll.position.y = _scroll_size
		return

	_scroll.position.y -= delta * _scroll_speed
