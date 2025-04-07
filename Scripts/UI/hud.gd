extends PanelContainer

@onready var _progress_bar: ProgressBar = $HBoxContainer/ProgressBar
@onready var _progress_bar_timer: Timer = $HBoxContainer/ProgressBar/Timer
@onready var _damage_bar: ProgressBar = $HBoxContainer/ProgressBar/DamageBar

@onready var _coin_count_label: Label = $HBoxContainer/CoinCount/Label
@onready var _metal_rating_label: Label = $HBoxContainer/MetalRating/Label

func _ready() -> void:
	EventBus.reset_level.connect(_on_level_start)
	EventBus.reset_character_energy.connect(_on_energy_reset)
	EventBus.reduce_energy.connect(_on_energy_reduced)
	EventBus.acquire_item.connect(_on_item_acquired)
	EventBus.item_found.connect(_on_item_found)
	EventBus.item_lost.connect(_on_item_lost)

func _on_level_start(_player_start: Vector2, goal: int):
	_coin_count_label.text = "0 / " + str(goal)
	_metal_rating_label.text = "00.0"

func _on_energy_reset(starting_energy: float):
	_progress_bar.max_value = starting_energy
	_progress_bar.value = starting_energy

	_damage_bar.max_value = starting_energy
	_damage_bar.value = starting_energy

func _on_energy_reduced(prev_energy: int, remaining_energy: int, is_dig: bool):
	if is_dig && remaining_energy < prev_energy:
		_progress_bar_timer.start()

	_progress_bar.value = remaining_energy
	if _progress_bar_timer.time_left <= 0:
		# If there isn't a timer active, make the damage bar follow the progress bar
		_damage_bar.value = _progress_bar.value

func _on_item_acquired(_item: Item, total_coins: int, goal: int):
	# TODO: VFX/Animations and whatever else
	# TODO: Lerp this value up
	_coin_count_label.text = str(total_coins) + " / " + str(goal)
	_metal_rating_label.text = "00.0"

func _on_item_found(item: Item):
	# TODO: Lerp this value up
	_metal_rating_label.text = str(item.metallic_score)

func _on_item_lost():
	# TODO: Lerp this value down
	_metal_rating_label.text = "00.0"

func _on_timer_timeout():
	_damage_bar.value = _progress_bar.value
