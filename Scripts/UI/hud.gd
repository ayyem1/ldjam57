extends HBoxContainer

@onready var _progress_bar: ProgressBar = $ProgressBar
@onready var _coin_count_label: Label = $CoinCount/Label
@onready var _metal_rating_label: Label = $MetalRating/Label

func _ready() -> void:
	EventBus.start_level.connect(_on_level_start)
	EventBus.reset_character_energy.connect(_on_energy_reset)
	EventBus.reduce_energy.connect(_on_energy_reduced)
	EventBus.acquire_item.connect(_on_item_acquired)
	EventBus.item_found.connect(_on_item_found)
	EventBus.item_lost.connect(_on_item_lost)

func _on_level_start():
	_coin_count_label.text = str(0)
	_metal_rating_label.text = str(0)

func _on_energy_reset(starting_energy: float):
	pass
	_progress_bar.max_value = starting_energy
	_progress_bar.value = starting_energy

func _on_energy_reduced(remaining: int):
	# TODO: VFX/Animations and whatever else
	_progress_bar.value = remaining

func _on_item_acquired(item: Item, total_coins: int):
	# TODO: VFX/Animations and whatever else
	_coin_count_label.text = str(total_coins)

func _on_item_found(item: Item):
	# TODO: Lerp this value up
	_metal_rating_label.text = str(item.metallic_score)

func _on_item_lost():
	# TODO: Lerp this value down
	_metal_rating_label.text = str(0)