class_name HealthUI extends Control

signal ratio_update(value: float)

@export var _hide_when_full := false
@onready var health_bar: Range = %HealthBar
@onready var red_under_bar: Range = %RedUnderBar

func set_health_ratio(value: float, insta_red := false) -> void:
	if _hide_when_full and value >= 1.0 :
		hide()
	elif _hide_when_full and value < 1.0:
		show()
	value = clampf(value, 0.0, 1.0)
	var is_healing : bool = value > health_bar.ratio
	health_bar.set_as_ratio(value)
	ratio_update.emit(value)
	if is_healing or insta_red: 
		red_under_bar.set_as_ratio(value-0.01)

func get_ratio() -> float: return health_bar.ratio

func _process(delta: float) -> void:
	if red_under_bar.ratio >= health_bar.ratio:
		delta *= GameSpeed.get_delta_mod()
		red_under_bar.ratio -= delta
