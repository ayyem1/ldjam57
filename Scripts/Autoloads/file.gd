extends Node

# NOTE: You can change the extensions to .tres for plaintext or .res for binary.
# For indie games, we care more about debugging player issues
# than preventing cheating, so we will leave these as plaintext.
const SETTINGS_PATH: String = "user://settings.tres" 
const PROGRESS_PATH: String = "user://progress.tres"

var settings: Settings
var progress: Progress

func _ready() -> void:
    if ResourceLoader.exists(SETTINGS_PATH):
        settings = ResourceLoader.load(SETTINGS_PATH)
    else:
        settings = Settings.new()
        ResourceSaver.save(settings, SETTINGS_PATH)

func save_settings():
    ResourceSaver.save(settings, SETTINGS_PATH)

func progress_file_exists() -> bool:
    return ResourceLoader.exists(PROGRESS_PATH)

func new_game():
    progress = Progress.new()

func save_game():
    ResourceSaver.save(progress, PROGRESS_PATH)

func load_game():
    progress = ResourceLoader.load(PROGRESS_PATH)
