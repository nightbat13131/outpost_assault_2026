class_name MouseInteractionNodeSticky extends MouseInteractionNode

var _is_selected := false: set = set_is_selected

@export var while_selected_cursor: CustomCursor

func set_is_selected(is_selected: bool) -> void:
	_is_selected = is_selected
	_send_cursor()
	if debug:
		prints(_collision_node.name, " set selected ", is_selected)

func _send_cursor() -> void:
	if _mouse_in and _is_selected:
		if while_selected_cursor:
				CursorSetter.cursor_overwrite_update(self, while_selected_cursor)
				return
	if _mouse_in:
		if mouse_in_cursor:
			CursorSetter.cursor_overwrite(self, mouse_in_cursor, true)
			return
	CursorSetter.cursor_overwrite(self, null, false)
