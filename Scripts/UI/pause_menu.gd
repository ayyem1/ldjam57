class_name PauseMenu extends Menu

func _on_continue_pressed() -> void:
	EventBus.toggle_pause.emit()

func _on_settings_pressed() -> void:
	EventBus.settings_menu_clicked.emit()

func _on_exit_pressed() -> void:
	EventBus.exit_to_title.emit()

func _on_instructions_pressed():
	EventBus.instructions_clicked.emit()
