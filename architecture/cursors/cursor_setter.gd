class_name CursorSetter extends Node

@export var _cursors : Array[CustomCursor]

static var _overwrite_requester: Object
#static var _overwrite_cursor: CustomCursor 
static var _default_cursor : CustomCursor

func _ready() -> void:
	for each in _cursors:
		each.activate()
		if each.cursor_shape == Input.CURSOR_ARROW:
			_default_cursor = each

static func cursor_overwrite(object: Object, cursor_info: CustomCursor, start_overwrite:= true) -> void:
	if start_overwrite:
		_start_cursor_(object, cursor_info)
	else:
		_end_cursor_(object)

static func _start_cursor_(object: Object, cursor_info: CustomCursor) -> void:
	_overwrite_requester = object
	cursor_info.activate_as_default_overwrite()


static func _end_cursor_(object: Object) -> void:
	if object != _overwrite_requester: 
		return
	if _default_cursor:
		_default_cursor.activate()
	object = null
