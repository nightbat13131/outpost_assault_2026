@tool
extends "res://addons/Button3D_addon/Button3D.gd"

func _ready():
	mouse_entered.connect(_mouse_entered_area)
	mouse_exited.connect(_mouse_exited_area)
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	prints(self.text)


var is_mouse_inside: bool = false:
	set(value):
		prints(value, "is_mouse_inside button")
		is_mouse_inside = value
		if is_mouse_inside:
			
			modulate = Color.RED
		else:
			modulate = Color.GREEN 



func _mouse_entered_area() -> void:
	is_mouse_inside = true
	# Notify the viewport that the mouse is now hovering it.
	#node_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)


func _mouse_exited_area() -> void:
	# Notify the viewport that the mouse is no longer hovering it.
	#node_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)
	is_mouse_inside = false
