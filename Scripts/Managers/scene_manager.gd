class_name SceneManager extends Node

@export var _background_track: AudioStream
@warning_ignore("unused_private_class_variable")
@export var _settings_menu: Menu
@export var _fade: FadeController

func _ready() -> void:
	Music.play_track(_background_track)
	await _fade.to_clear()

func change_scene(path: String):
	# NOTE: The order of these matters. We should await the one that takes the longest.
	Music.fade_out()
	await _fade.to_black()

	get_tree().paused = false
	get_tree().change_scene_to_file(path)
