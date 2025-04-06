class_name GameManager extends SceneManager

@onready var _pause_menu: PauseMenu = $"UI/PauseMenu"
@onready var _game_over_menu: GameOverMenu = $"UI/GameOverMenu"

var is_game_active: bool = false

func _ready() -> void:
	super._ready()

	EventBus.change_level.connect(_on_change_level)
	EventBus.exit_pause_menu.connect(toggle_pause)
	EventBus.settings_menu_clicked.connect(_on_settings_pressed)
	EventBus.exit_to_title.connect(_on_exit_pressed)
	EventBus.toggle_pause.connect(toggle_pause)
	EventBus.end_level.connect(_on_level_over)
	EventBus.restart_level.connect(start_game)


	# TODO: Fix this race condition. this emits in ready while player connects to emit on ready
	start_game()

func toggle_pause():
	var was_paused = get_tree().paused
	if was_paused && !_pause_menu.is_active:
		# Pause menu is hidden because another menu was opened from it.
		# In this case we do not want to process the pause input
		return

	if was_paused:
		_pause_menu.close()
	else:
		_pause_menu.open()

	get_tree().paused = !was_paused

func start_game():
	print("start_game")
	_game_over_menu.close()
	EventBus.start_level.emit()
	is_game_active = true

func _on_change_level(level_name: String) -> void:
	pass

func _on_exit_pressed() -> void:
	change_scene("res://Scenes/title.tscn")


func _on_settings_pressed() -> void:
	_settings_menu.open(_pause_menu)


func _on_level_over(did_win: bool):
	is_game_active = false
	_game_over_menu.open()
