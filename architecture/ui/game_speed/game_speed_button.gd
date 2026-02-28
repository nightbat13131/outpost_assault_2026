class_name Button_GameSpeed extends ButtonEnhanced

signal speed_pressed(multiplier: float)

@export var multiplier : float 

func _on_pressed() -> void:
	speed_pressed.emit(multiplier)

func remote_press() -> void:
	set_pressed(true)
	pressed.emit()
