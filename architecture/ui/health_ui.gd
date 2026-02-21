class_name HealthUI extends Control

signal ratio_update(value: float)
signal suppression_update(value: bool)

@export var _hide_when_full := false
@export var _hide_when_empty := false
@onready var health_bar: Range = %HealthBar
@onready var red_under_bar: Range = %RedUnderBar
var _suppress := false : set = set_suppressed

func set_health_ratio(value: float, insta_red := false) -> void:
	if value <= 0 and _hide_when_empty:
		hide()
	elif value >= 1.0 and _hide_when_full: 
		hide()
	else:
		show()
	if _hide_when_empty:
		if value <= 0.0:
			hide()
	value = clampf(value, 0.0, 1.0)
	var is_healing : bool = value > health_bar.ratio
	health_bar.set_as_ratio(value)
	ratio_update.emit(value)
	if is_healing or insta_red: 
		red_under_bar.set_as_ratio(value-0.01)

func get_ratio() -> float: return health_bar.ratio

func _process(delta: float) -> void:
	if red_under_bar.ratio >= get_ratio():
		delta *= GameSpeed.get_delta_mod()
		red_under_bar.ratio -= delta

func set_suppressed(_is_suppressed) -> void:
	_suppress = _is_suppressed 
	suppression_update.emit(_suppress)
	if _suppress:
		hide()
	else:
		show()
