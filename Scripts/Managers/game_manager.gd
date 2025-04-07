class_name GameManager extends SceneManager

const NUM_LEVELS: int = 3

@onready var _pause_menu: PauseMenu = $"UI/PauseMenu"
@onready var _instructions: Menu = $UI/Instructions
@onready var _game_over_menu: GameOverMenu = $"UI/GameOverMenu"

@onready var _player_start: Marker2D = $PlayerStart
@onready var _level01: PackedScene = preload("res://Scenes/Levels/level1.tscn")
@onready var _level02: PackedScene = preload("res://Scenes/Levels/level2.tscn")
@onready var _level03: PackedScene = preload("res://Scenes/Levels/level3.tscn")

var is_game_active: bool = false
var _level: Level

func _ready() -> void:
	super._ready()

	EventBus.exit_pause_menu.connect(toggle_pause)
	EventBus.settings_menu_clicked.connect(_on_settings_pressed)
	EventBus.instructions_clicked.connect(_on_instructions_pressed)
	EventBus.exit_to_title.connect(_on_exit_pressed)
	EventBus.toggle_pause.connect(toggle_pause)
	EventBus.restart_level.connect(_on_restart_level)
	EventBus.acquire_item.connect(_on_item_acquired)
	EventBus.next_level.connect(_go_to_next_level)
	EventBus.end_level.connect(_on_level_end)

	load_level()

	call_deferred("_start_game_for_first_time")

func load_level():
	if _level:
		_level.queue_free()
	
	match File.progress.current_level:
		1:
			_level = _level01.instantiate()
		2:
			_level = _level02.instantiate()
		3:
			_level = _level03.instantiate()
	
	add_child(_level)
	_level.reset_items(true)
	
	
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
	_game_over_menu.close()
	EventBus.start_level.emit()
	is_game_active = true

func _start_game_for_first_time():
	EventBus.reset_level.emit(_player_start.global_position, _level.goal)
	start_game()

func _on_restart_level():
	_level.reset_items(true)
	EventBus.reset_level.emit(_player_start.global_position, _level.goal)
	await _fade.to_clear(1)
	start_game()

func _go_to_next_level():
	File.progress.current_level += 1
	load_level()
	EventBus.reset_level.emit(_player_start.global_position, _level.goal)
	await _fade.to_clear(1)
	start_game()

func _on_exit_pressed() -> void:
	change_scene("res://Scenes/title.tscn")

func _on_settings_pressed() -> void:
	_settings_menu.open(_pause_menu)

func _on_instructions_pressed() -> void:
	_instructions.open(_pause_menu)

func _on_level_end(_did_win: bool):
	is_game_active = false
	await _fade.to_black(1)
	EventBus.show_game_over_menu.emit(_did_win)

func _on_item_acquired(_item: Item, collected_coins: int, _goal: int):
	if collected_coins >= _level.goal:
		is_game_active = false
		if File.progress.current_level < NUM_LEVELS:
			EventBus.end_level.emit(true)
		else:
			EventBus.end_content.emit()
			change_scene("res://Scenes/credits.tscn")
