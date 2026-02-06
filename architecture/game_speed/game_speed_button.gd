class_name Button_GameSpeed extends Button
# is a button group, 
# is toggled

signal speed_pressed(multiplier: float)

@export var multiplier : float 

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	speed_pressed.emit(multiplier)

func remote_press() -> void:
	set_pressed(true)
	pressed.emit()
