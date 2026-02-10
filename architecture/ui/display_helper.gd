class_name DisplayHelper extends Resource

static var DEFAULT_POS = Vector2.INF

var _parent : Object
var _health_ui : HealthUI
var _position : Vector2 = DEFAULT_POS

func get_display_name() -> String:
	if _parent:
		return str(_parent.name)
	return "No Parent"

func _init(parent: Object, health_ui: HealthUI) -> void:
	_parent = parent
	_health_ui = health_ui
	if _parent:
		_position = _parent.get_position()

func get_health_ui() -> HealthUI: return _health_ui

func get_camera_position() -> Vector2: return _position
