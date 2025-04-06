extends Area2D

@onready var _proximity_audio_stream_player: AudioStreamPlayer = $ProximityAudioStreamPlayer
@onready var _quack_audio_stream_player: AudioStreamPlayer = $QuackAudioStreamPlayer

var active_item: Item

func destroy_active_item():
	if !active_item:
		return
	
	active_item.queue_free()
	active_item = null

func _on_body_exited(item: Item) -> void:
	if active_item == item:
		_stop_audio()
		active_item = null
		EventBus.item_lost.emit()

func _on_body_entered(item: Item) -> void:
	active_item = item
	_play_audio()
	EventBus.item_found.emit(active_item)

func _play_audio():
	if active_item.is_dud:
		_quack_audio_stream_player.play()
	else:
		_proximity_audio_stream_player.play()

func _stop_audio():
	if active_item.is_dud:
		_quack_audio_stream_player.stop()
	else:
		_proximity_audio_stream_player.stop()