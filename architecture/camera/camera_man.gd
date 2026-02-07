@tool
class_name CameraMan extends CharacterBody2D
## TODO: decomisioned Jan 6 2026

## TODO add accecloration to movement
## zoom might cause collision overlap issues if I change the size shape? 
## HOME = snap to home base position
## midle mouse button click drag

var min_zoom = .5
var max_zoom = 2.5:
	set(value):
		max_zoom = value
		$CollisionShape2D.get_shape().radius = get_viewport_rect().size.y*.5 * 1 / max_zoom
		queue_redraw()

static var standard_cursor : CustomCursor = load("uid://cb44gaxpio06i")
static var dragging_cursor : CustomCursor = load("uid://dbw2fwmjcemp3")
static var control_context : GUIDEMappingContext = load("uid://c2cn6t0iqekow")
static var action_move_keys : GUIDEAction = load("uid://ta3akt5mo5ib")
static var action_move_drag : GUIDEAction = load("uid://da8kwewg6uhwn")
static var action_zoom : GUIDEAction = load("uid://bl4ky3gf6gcji")
@export var debug := true

@onready var camera_2d: Camera2D = %Camera2D
var _is_drag_cursor := true : set = _set_is_drag_cursor

var _max_speed := 1000.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if control_context:
		GUIDE.enable_mapping_context(control_context)
	if action_zoom:
		action_zoom.triggered.connect(_on_zoom)

func _draw() -> void:
	if Engine.is_editor_hint() or debug:
		var base_radius = get_viewport_rect().size.y*.5
		draw_circle(Vector2.ZERO, base_radius, Color.WHITE, false, 2.0, false) #100%
		draw_circle(Vector2.ZERO, base_radius * 1/min_zoom, Color.RED, false, 2.0, false)
		draw_circle(Vector2.ZERO, base_radius * 1/max_zoom, Color.GREEN, false, 2.0, false)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var direction := Vector2.ZERO
	if action_move_keys and action_move_drag:
		if action_move_keys.is_triggered():
			direction = action_move_keys.value_axis_2d.normalized()
			velocity = direction * get_speed()
		elif action_move_drag.is_triggered():
			direction = action_move_drag.value_axis_2d
			print(direction)
			_set_is_drag_cursor(true)
		else:
			_set_is_drag_cursor(false)

		velocity = direction * get_speed()
		move_and_slide()
			

func get_speed() -> float:
	return _max_speed * (1/camera_2d.zoom.length())

func _on_zoom() -> void:
	var value = action_zoom.value_axis_1d*-1
	# camera_2d.zoom *= 1.0 + (.1 * value)
	var new_length = clamp(camera_2d.get_zoom().x*(1 + .1*value), min_zoom, max_zoom)
	#prints(value, camera_2d.get_zoom().length(), camera_2d.get_zoom().length()*(1 + .1*value) ,  "->", new_length, Vector2.ONE.normalized() * new_length )
	camera_2d.set_zoom(Vector2(new_length, new_length))

func _set_is_drag_cursor(is_on) -> void:
	if _is_drag_cursor == is_on:
		return  # stop processing if no change
	_is_drag_cursor = is_on
	if _is_drag_cursor:
		dragging_cursor.force_to_default()
	else: 
		standard_cursor.force_to_default()
