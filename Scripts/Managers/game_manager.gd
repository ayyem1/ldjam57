class_name GameManager extends SceneManager

@onready var _character: CharacterBody2D = $Character
@onready var _player: Node = $Player
@onready var _pause_menu: Menu = $"UI/PauseMenu"

func _ready() -> void:
	super._ready()
	EventBus.change_level.connect(_on_change_level)

func _on_change_level(level_name: String) -> void:
	pass

func toggle_pause():
	var was_paused = get_tree().paused
	if was_paused:
		_pause_menu.close()
	else:
		_pause_menu.open()

	get_tree().paused = !was_paused

func _on_exit_pressed() -> void:
	change_scene("res://Scenes/title.tscn")


func _on_settings_pressed() -> void:
	_settings_menu.open(_pause_menu)
