class_name CustomCursor extends Resource

@export var cursor_shape : Input.CursorShape

func force_to_default() -> void: Input.set_default_cursor_shape(cursor_shape)

func apply_to_control(control: Control) -> void:
	control.set_default_cursor_shape(cursor_shape as Control.CursorShape)
