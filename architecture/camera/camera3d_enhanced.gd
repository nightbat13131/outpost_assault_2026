#@tool
class_name Camera3D_Enhanced extends Camera3D
## TODO add accecloration to hand movement
## TODO add tween to remote movement
## TODO fix midle mouse button click drag

const Visual_Layer_PrimaryOnly = 2
const Visual_Layer_PrimaryAndSide = 1

const ZOOM_SPEED := .05
const TWEEN_DURATION := .5
## Reminder that MinZoom does not work when running the Level without the UI
var min_zoom : float = .5 : set = _set_min_zoom
var max_zoom : float = 2.5
var _zoom := 1.0: set = _set_zoom, get = _get_zoom
var initial_height : float
var initial_fov : float

static var standard_cursor : CustomCursor = load("uid://cb44gaxpio06i")
static var dragging_cursor : CustomCursor = load("uid://dbw2fwmjcemp3")

static var control_context : GUIDEMappingContext = load("uid://c2cn6t0iqekow")
static var action_move_keys : GUIDEAction = load("uid://ta3akt5mo5ib")
static var action_move_drag : GUIDEAction = load("uid://da8kwewg6uhwn")
static var action_move_home : GUIDEAction = load("uid://dngiyneq1ddvy")
static var action_zoom : GUIDEAction = load("uid://bl4ky3gf6gcji")

@export var debug := true

var east_limit:  VisibleOnScreenNotifier3D
var west_limit:  VisibleOnScreenNotifier3D
var north_limit: VisibleOnScreenNotifier3D
var south_limit: VisibleOnScreenNotifier3D

var _is_drag_cursor := true : set = _set_is_drag_cursor
var _max_speed := 5.0
var _velocity := Vector3.ZERO
var _is_remote_moving := false : set = _set_is_remote_moving
var _viewport : SubViewport: get = get_subviewport
var _last_drag_direction : Vector2

func _ready() -> void:
	## TODO dev values
	initial_height = global_position.y
	initial_fov = fov
	##
	if Engine.is_editor_hint():
		return
	if control_context:
		GUIDE.enable_mapping_context(control_context)
	if action_zoom:
		action_zoom.triggered.connect(_on_zoom)
	if action_move_home:
		action_move_home.triggered.connect(_on_home)

func _process(delta: float) -> void:
	if !is_current():
		return
	if Engine.is_editor_hint():
		return
	if _is_remote_moving:
		return
	if action_move_keys and action_move_drag:
		var direction := Vector2.ZERO
		if action_move_keys.is_triggered():
			direction = action_move_keys.value_axis_2d.normalized()
			_last_drag_direction = Vector2.ZERO
		elif action_move_drag.is_triggered():
			direction = action_move_drag.value_axis_2d.normalized()#drag resistance? )
			if direction == Vector2.ZERO:
				direction = _last_drag_direction
			else:
				_last_drag_direction = direction
			_set_is_drag_cursor(true)
		else:
			_last_drag_direction = Vector2.ZERO
			_set_is_drag_cursor(false)
		if direction == Vector2.ZERO:
			return
		_velocity = Vector3(direction.x, 0.0, direction.y ) * _get_speed() * delta
		_move_to(position + _velocity)

func get_subviewport() -> SubViewport: return _viewport

func _on_zoom() -> void:
	if _is_remote_moving:
		return
	var value = action_zoom.value_axis_1d
	var new_zoom = clamp(_get_zoom()*(1 + ZOOM_SPEED * value), min_zoom, max_zoom)
	_set_zoom(new_zoom)
	if action_move_keys and action_move_drag: 
		if !(action_move_keys.is_triggered() or action_move_drag.is_triggered()):
			# player not also scrolling camera while changing zoom
			_move_to(position)

func _on_home() -> void:
	if _is_remote_moving:
		return
	var home := PlayerOutpost.get_instance()
	if home:
		remote_move_to(home.global_position)

func _set_is_remote_moving(is_moving: bool) -> void: _is_remote_moving = is_moving

func _set_is_drag_cursor(is_on) -> void:
	if _is_drag_cursor == is_on:
		return  # stop processing if no change
	_is_drag_cursor = is_on
	if _is_drag_cursor:
		dragging_cursor.force_to_default()
	else: 
		standard_cursor.force_to_default()

func _get_speed() -> float: return _max_speed * Utilities.try_divide(1, _get_zoom(), 1.0)

func _set_min_zoom(value: float) -> void:
	min_zoom = value
	if Engine.is_editor_hint():
		return
	if _get_zoom() < min_zoom:
		_set_zoom(min_zoom)

func _set_zoom(value: float) -> void:
	var zoom_delta = _zoom - value
	if is_full_screen() and zoom_delta < 0:
		return
		
	_zoom = clampf(value, min_zoom, max_zoom)
	## Change y? 
	var new_y := initial_height * _zoom
	global_position.y = new_y
	## Change FOV?
	#var new_fov = clampf(initial_fov * _zoom, 1, 179)
	#fov = new_fov

func _get_zoom() -> float: return _zoom

func remote_move_to(next_position : Vector3, target_zoom: float= 0.0) -> void: 
	var tween = create_tween()
	_set_is_remote_moving(true)
	tween.tween_method(_move_to, position, next_position, TWEEN_DURATION)
	tween.tween_callback(_set_is_remote_moving.bind(false) )
	if target_zoom != 0:
		# TODO include zoom_change ?
		pass

func _move_to(next_position_: Vector3) -> void:
	"""
	var screen_size := get_viewport_rect().size / _get_zoom()
	var internal_bounds = Rect2(_limit_rect.position + screen_size * .5, _limit_rect.size - screen_size) # y works GREAT
	if screen_size.x >= _limit_rect.size.x:
		internal_bounds.size.x = 10
		internal_bounds.position.x = _limit_rect.get_center().x
	if screen_size.y >= _limit_rect.size.y:
		internal_bounds.size.y = 10
		internal_bounds.position.y = _limit_rect.get_center().y
	next_position_.x = clamp(next_position_.x, internal_bounds.position.x, internal_bounds.end.x)
	next_position_.z = clamp(next_position_.y, internal_bounds.position.y, internal_bounds.end.y)
	"""
	if is_full_screen():
		return # no change posible
	var position_delta = position - next_position_
	if position_delta.x > 0 : 
		if west_limit:
			if west_limit.is_on_screen():
				next_position_.x = position.x
	elif position_delta.x < 0:
		if east_limit:
			if east_limit.is_on_screen():
				next_position_.x = position.x
				
	if position_delta.z > 0 : 
		if north_limit:
			if north_limit.is_on_screen():
				next_position_.z = position.z
	elif position_delta.z < 0:
		if south_limit:
			if south_limit.is_on_screen():
				next_position_.z = position.z
	position.x = next_position_.x
	position.z = next_position_.z

func is_full_screen() -> bool:
	if west_limit:
		if !west_limit.is_on_screen():
			return false
	if east_limit:
		if !east_limit.is_on_screen():
			return false
	if north_limit:
		if !north_limit.is_on_screen():
			return false
	if south_limit:
		if !south_limit.is_on_screen():
			return false
	return true
