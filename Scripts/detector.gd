extends Area2D

@onready var _small_proximity_stream: AudioStreamPlayer = $SmallProximityASP
@onready var _medium_proximity_stream: AudioStreamPlayer = $MediumProximityASP
@onready var _large_proximity_stream: AudioStreamPlayer = $LargeProximityASP
@onready var _dud_audio_stream: AudioStreamPlayer = $DudASP

var active_item: Item
var _active_stream: AudioStreamPlayer

func disable_active_item():
	if !active_item:
		return
	
	#TODO: Move this to LevelManager
	active_item.visible = false
	active_item.set_collision_layer_value(17, false)
	active_item = null

func _on_body_exited(item: Item) -> void:
	if active_item == item:
		# if _active_stream:
		# 	_active_stream.stop()
		active_item = null
		EventBus.item_lost.emit()

func _on_body_entered(item: Item) -> void:
	if active_item && _active_stream:
		_active_stream.stop()

	active_item = item
	_play_audio()
	EventBus.item_found.emit(active_item)

func _play_audio():
	if active_item.is_dud:
		_active_stream = _dud_audio_stream
		# _dud_audio_stream.play()
	elif active_item.size == Item.Size.Small:
		_active_stream = _small_proximity_stream
		# _small_proximity_stream.play()
	elif active_item.size == Item.Size.Medium:
		_active_stream = _medium_proximity_stream
		# _medium_proximity_stream.play()
	elif active_item.size == Item.Size.Large:
		_active_stream = _large_proximity_stream
		# _large_proximity_stream.play()
	
	if _active_stream:
		_active_stream.play()