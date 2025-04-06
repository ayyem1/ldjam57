class_name GameOverMenu extends Menu 

func _on_exit_pressed() -> void:
	EventBus.exit_to_title.emit()


func _on_restart_pressed() -> void:
	EventBus.restart_level.emit()
