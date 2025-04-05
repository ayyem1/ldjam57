class_name SettingsMenu extends Menu

@onready var _camera_invert_x_checkbox: CheckBox = $"VBoxContainer/GridContainer/CameraInvertXCheckBox"
@onready var _camera_invert_y_checkbox: CheckBox = $"VBoxContainer/GridContainer/CameraInvertYCheckBox"
@onready var _volume_slider: HSlider = $"VBoxContainer/GridContainer/VolumeSlider"

func _ready() -> void:
    _camera_invert_x_checkbox.button_pressed = File.settings.camera_invert_x
    _camera_invert_y_checkbox.button_pressed = File.settings.camera_invert_y
    _volume_slider.value = File.settings.volume
    EventBus.linear_volume_changed.emit(_volume_slider.value)

func _on_volume_slider_value_changed(value: float) -> void:
    File.settings.volume = value;
    EventBus.linear_volume_changed.emit(value)

func _on_camera_invert_y_check_box_toggled(toggled_on: bool) -> void:
    File.settings.camera_invert_x = toggled_on

func _on_camera_invert_x_check_box_toggled(toggled_on: bool) -> void:
    File.settings.camera_invert_y = toggled_on

func close():
    File.save_settings()
    super.close()