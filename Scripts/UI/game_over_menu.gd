class_name GameOverMenu extends Menu

@onready var title: Label = $VBoxContainer/Title
@onready var restart_button: Button = $VBoxContainer/VButtonContainer/Restart

var _did_win: bool = false

func _ready() -> void:
	EventBus.show_game_over_menu.connect(_on_show_game_over_menu)

func _on_exit_pressed() -> void:
	EventBus.exit_to_title.emit()

	close()

func _on_restart_pressed() -> void:
	if _did_win:
		EventBus.next_level.emit()
	else:
		EventBus.restart_level.emit()
	
	close()

func _on_show_game_over_menu(did_win: bool):
	_did_win = did_win
	if did_win:
		title.text = "YOU WIN"
		restart_button.text = "NEXT LEVEL"
	else:
		title.text = "YOU LOSE"
		restart_button.text = "RESTART LEVEL"

	open()