extends Area3D
## https://github.com/godotengine/godot-demo-projects/blob/master/viewport/gui_in_3d/gui_3d.gd

## Used for checking if the mouse is inside the Area3D.
var is_mouse_inside: bool = false:
	set(value):
		prints(value, "is_mouse_inside")
		is_mouse_inside = value

func _ready() -> void:
	#mouse_entered.connect(_mouse_entered_area)
	#mouse_exited.connect(_mouse_exited_area)
	input_event.connect(_on_thing)

func _on_thing(_camera: Camera3D, input_event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if input_event.is_pressed():
		prints("A", input_event)


func _mouse_entered_area() -> void:
	is_mouse_inside = true
	# Notify the viewport that the mouse is now hovering it.
	#node_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)


func _mouse_exited_area() -> void:
	# Notify the viewport that the mouse is no longer hovering it.
	#node_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)
	is_mouse_inside = false
