class_name MouseInteractionNode extends Node

signal selected
signal mouse_in(is_in: bool)

@export var _collision_node: CollisionObject3D
@export var debug := false
@export var action_select : GUIDEAction ## curently nested within the context_camera
@export var mouse_in_cursor: CustomCursor

var _mouse_in := false: 
	set(is_in):
		_mouse_in = is_in
		mouse_in.emit(_mouse_in)

func _ready() -> void:
	_collision_node.input_event.connect(_on_input_event)
	_collision_node.mouse_entered.connect(_on_mouse_entered)
	_collision_node.mouse_exited.connect(_on_mouse_exited)

func _on_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	# only triggered while mouse is overlapping the building. 
	if action_select:
		if action_select.is_triggered():
			selected.emit()
			if print_debug:
				prints(_collision_node.name, "select")

func _on_mouse_entered() -> void:
	_mouse_in = true
	_send_cursor()
	if debug:
		prints(_collision_node.name, "entered")

func _on_mouse_exited() -> void:
	_mouse_in = false
	_send_cursor()
	if debug:
		prints(_collision_node.name, "exit")

func _send_cursor() -> void:
	if _mouse_in:
		if mouse_in_cursor:
			CursorSetter.cursor_overwrite(self, mouse_in_cursor, true)
	else: 
		CursorSetter.cursor_overwrite(self, null, false)
