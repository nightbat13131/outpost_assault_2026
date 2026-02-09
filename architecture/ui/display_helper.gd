class_name DisplayHelper extends Resource

var _parent : Object
var _health_ui : HealthUI

func get_display_name() -> String:
	if _parent:
		return str(_parent.name)
	return "No Parent"

func _init(parent: Object, health_ui: HealthUI) -> void:
	_parent = parent
	_health_ui = health_ui

func get_health_ui() -> HealthUI: return _health_ui
