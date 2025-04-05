class_name FadeController extends ColorRect

const CLEAR = Color(0, 0, 0, 0)
@export var _default_duration: float = 1.0

var _tween: Tween

func _ready() -> void:
    visible = true

func to_clear(in_duration: float = _default_duration) -> Signal:
    return _to_color(CLEAR, in_duration)


func to_black(in_duration: float = _default_duration) -> Signal:
    return _to_color(Color.BLACK, in_duration)

func _to_color(in_color: Color, in_duration: float) -> Signal:
    if _tween && _tween.is_running():
        _tween.kill()

    _tween = create_tween()
    _tween.tween_property(self, "color", in_color, in_duration)

    return _tween.finished
