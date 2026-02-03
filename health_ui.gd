class_name HealthUI extends Control

@onready var health_bar: Range = %HealthBar
@onready var red_under_bar: Range = %RedUnderBar

func set_healt_ratio(value: float) -> void:
	value = clampf(value, 0.0, 1.0)
	var is_healing : bool = value > health_bar.ratio
	health_bar.set_as_ratio(value)
	if is_healing: 
		red_under_bar.set_as_ratio(value-0.01)

func _process(delta: float) -> void:
	if red_under_bar.ratio >= health_bar.ratio:
		delta *= GameSpeed.get_delta_mod()
		red_under_bar.ratio -= delta
