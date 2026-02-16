class_name CustomCursor extends Resource

@export var cursor_shape : Input.CursorShape
@export var cursor_image : Texture2D
@export var hotspot := Vector2(8,8)

func force_to_default() -> void: Input.set_default_cursor_shape(cursor_shape)

func activate() -> void:
	if cursor_image:
		Input.set_custom_mouse_cursor(
			cursor_image, cursor_shape, hotspot
		)

func apply_to_control(control: Control) -> void:
	control.set_default_cursor_shape(cursor_shape as Control.CursorShape)
