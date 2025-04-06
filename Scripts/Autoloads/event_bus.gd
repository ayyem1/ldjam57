extends Node

@warning_ignore_start("unused_signal")
signal linear_volume_changed(new_linear_volume: float)

signal change_level(level_name: String)

signal exit_pause_menu()

signal exit_to_title()

signal settings_menu_clicked()

signal start_level()

signal restart_level()

signal end_level(did_win: bool)

signal toggle_pause()