class_name GameOverMenu extends Menu

@onready var title: Label = $VBoxContainer/Title
func _ready() -> void:
	EventBus.end_level.connect(_on_level_over)
	EventBus.restart_level.connect(_on_restart_level)

func _on_exit_pressed() -> void:
	EventBus.exit_to_title.emit()

func _on_restart_pressed() -> void:
	EventBus.restart_level.emit()

func _on_level_over(did_win: bool):
	if did_win:
		title.text = "YOU WIN"
	else:
		title.text = "YOU LOSE"
	open()

func _on_restart_level():
	close()