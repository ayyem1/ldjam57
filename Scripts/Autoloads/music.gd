extends AudioStreamPlayer

@export var _default_fade_duration: float = 1.0
var _tween: Tween

func _ready() -> void:
	volume_linear = 0
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.linear_volume_changed.connect(_on_volume_changed)

func _on_volume_changed(new_linear_volume: float):
	volume_linear = new_linear_volume

func play_track(track: AudioStream, fade_duration: float = _default_fade_duration) -> Signal:
	if playing:
		if track == stream:
			return _fade_volume(File.settings.volume, fade_duration)

		await _fade_volume(0, fade_duration)

	stream = track
	play()

	return _fade_volume(File.settings.volume, fade_duration)

func _fade_volume(target_linear_volume: float, fade_duration: float) -> Signal:
	if _tween && _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.tween_property(self, "volume_linear", target_linear_volume, fade_duration)
	return _tween.finished

func fade_out(fade_duration: float = _default_fade_duration):
	await _fade_volume(0, fade_duration)
	stop()
	stream = null
