class_name GameOverMenu extends Menu 

func _on_exit_pressed() -> void:
	print("Exit")
	EventBus.exit_to_title.emit()


func _on_restart_pressed() -> void:
	print("Restart")
	EventBus.restart_level.emit()
