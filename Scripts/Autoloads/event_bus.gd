extends Node

@warning_ignore_start("unused_signal")
signal linear_volume_changed(new_linear_volume: float)

signal change_level(level_name: String)

signal exit_pause_menu()

signal exit_to_title()

signal settings_menu_clicked()

signal instructions_clicked()

signal reset_level(player_start_po: Vector2, level_goal: int)

signal start_level(current_level: Level)

signal restart_level()

signal end_level(did_win: bool)

signal show_game_over_menu(did_win: bool)

signal next_level()

signal end_content()

signal toggle_pause()

signal reset_character_energy(starting_energy: float)

signal reduce_energy(prev_energy: int, remaining: int, is_dig)

signal acquire_item(item: Item, total_coins: int, goal: int)

signal item_found(item: Item)

signal item_lost()