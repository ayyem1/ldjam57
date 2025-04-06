class_name TitleManager extends SceneManager

@onready var _menu_buttons: Menu = $"CenterContainer/PanelContainer/Menu Buttons"

func _ready() -> void:
	super._ready()
	_menu_buttons.open()

func _on_new_game_pressed() -> void:
	File.new_game()
	change_scene("res://Scenes/game.tscn")

func _on_exit_pressed() -> void:
	File.save_game()
	_fade.to_black()
	get_tree().quit()

func _on_credits_pressed() -> void:
	change_scene("res://Scenes/credits.tscn")

func _on_settings_pressed() -> void:
	_settings_menu.open(_menu_buttons)
