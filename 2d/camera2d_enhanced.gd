@tool
class_name Camera2DEnhanced extends Camera2D

## TODO add accecloration to hand movement
## TODO add tween to remote movement
## TODO fix midle mouse button click drag

const ZOOM_SPEED := .05
const TWEEN_DURATION := .5
## Reminder that MinZoom does not work when running the Level without the UI
var min_zoom : float = .5 : set = set_min_zoom
var max_zoom : float = 2.5

static var standard_cursor : CustomCursor = load("uid://cb44gaxpio06i")
static var dragging_cursor : CustomCursor = load("uid://dbw2fwmjcemp3")

static var control_context : GUIDEMappingContext = load("uid://c2cn6t0iqekow")
static var action_move_keys : GUIDEAction = load("uid://ta3akt5mo5ib")
static var action_move_drag : GUIDEAction = load("uid://da8kwewg6uhwn")
static var action_move_home : GUIDEAction = load("uid://dngiyneq1ddvy")
static var action_zoom : GUIDEAction = load("uid://bl4ky3gf6gcji")

@export var debug := true
var _is_drag_cursor := true : set = _set_is_drag_cursor
var _limit_rect : Rect2
var _max_speed := 500.0
var _velocity := Vector2.ZERO
var _is_remote_moving := false : set = _set_is_remote_moving
var _viewport : SubViewport: get = get_subviewport
var _bounds : CameraBounds
var _last_drag_direction : Vector2

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if control_context:
		GUIDE.enable_mapping_context(control_context)
	if action_zoom:
		action_zoom.triggered.connect(_on_zoom)
	if action_move_home:
		action_move_home.triggered.connect(_on_home)
	setup_subviewport.call_deferred()

func _draw() -> void:
	if Engine.is_editor_hint() or debug:
		var base_radius = get_viewport_rect().size.y*.5
		draw_circle(Vector2.ZERO, base_radius, Color.WHITE, false, 2.0, false) #100%
		draw_circle(Vector2.ZERO, base_radius * 1/min_zoom, Color.GREEN, false, 2.0, false)
		draw_circle(Vector2.ZERO, base_radius * 1/max_zoom, Color.BLACK, false, 2.0, false)

func _process(delta: float) -> void:
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
		_velocity = direction * get_speed() * delta
		_move_to(position + _velocity)

func set_bound(bound: CameraBounds) -> void:
	_bounds = bound
	#set_limits(bound.get_limit_rect())
	_apply_bound()

func _apply_bound() -> void:
	# zoom can't be calculated within Resource without Node reference
	# Limit needs to be set before move to as limit restricts movement. 
	if !_bounds: # nothing to apply
		return
	if !is_inside_tree():
		await tree_entered
	var screen : Vector2
	if get_subviewport():
		screen = get_subviewport().size
	else: 
		screen = get_viewport_rect().size
	var limit_size =  _limit_rect.size #* .95
	var new_zoom = Vector2(
		screen.x / limit_size.x,
		screen.y / limit_size.y)
	if new_zoom.x < new_zoom.y: 
		set_min_zoom(new_zoom.y)
	else:
		set_min_zoom(new_zoom.x)
	remote_move_to(_bounds.get_camera_starting_position())
	queue_redraw()

func setup_subviewport() -> void: 
	var new_viewport = GameLevelUI.request_subviewport()
	if _viewport == new_viewport: # no change
		return 
	elif _viewport: # has a differnet viewport
		_viewport.size_changed.disconnect(_on_viewport_size_changed)
	_viewport = new_viewport
	if _viewport:
		if !_viewport.size_changed.is_connected(_on_viewport_size_changed):
			_viewport.size_changed.connect(_on_viewport_size_changed)
			_on_viewport_size_changed()

func get_subviewport() -> SubViewport: return _viewport

func _on_viewport_size_changed() -> void: _apply_bound()

func set_limits(rect: Rect2) -> void: _limit_rect = rect

func set_min_zoom(value: float) -> void:
	min_zoom = value
	if Engine.is_editor_hint():
		return
	if zoom.x < min_zoom:
		set_zoom(Vector2(min_zoom, min_zoom))

func get_speed() -> float: return _max_speed * (1/zoom.length())

func _on_zoom() -> void:
	var value = action_zoom.value_axis_1d
	var new_zoom = clamp(get_zoom().x*(1 + ZOOM_SPEED*value), min_zoom, max_zoom)
	set_zoom(Vector2(new_zoom, new_zoom))
	if action_move_keys and action_move_drag: 
		if !(action_move_keys.is_triggered() or action_move_drag.is_triggered()):
	#		# player not also scrolling camera while changing zoom
			_move_to(position)

func _on_home() -> void:
	#var home := PlayerOutpost2D.get_instance()
	#if home:
		#remote_move_to(home.global_position)
	pass

func _set_is_drag_cursor(is_on) -> void:
	if _is_drag_cursor == is_on:
		return  # stop processing if no change
	_is_drag_cursor = is_on
	if _is_drag_cursor:
		dragging_cursor.force_to_default()
	else: 
		standard_cursor.force_to_default()

func _set_is_remote_moving(is_moving: bool) -> void: _is_remote_moving = is_moving

func remote_move_to(next_position : Vector2, target_zoom:= Vector2.ZERO) -> void: 
	# TODO tween
	var tween = create_tween()
	_set_is_remote_moving(true)
	tween.tween_method(_move_to, position, next_position, TWEEN_DURATION)
	tween.tween_callback(_set_is_remote_moving.bind(false) )
#	_move_to(position_)
	if target_zoom != Vector2.ZERO:
		# TODO include zoom_change
		pass

func _move_to(next_position_: Vector2) -> void:
	var screen_size := get_viewport_rect().size / zoom.x
	var internal_bounds = Rect2(_limit_rect.position + screen_size * .5, _limit_rect.size - screen_size) # y works GREAT
	if screen_size.x >= _limit_rect.size.x:
		internal_bounds.size.x = 10
		internal_bounds.position.x = _limit_rect.get_center().x
	if screen_size.y >= _limit_rect.size.y:
		internal_bounds.size.y = 10
		internal_bounds.position.y = _limit_rect.get_center().y
	next_position_.y = clamp(next_position_.y, internal_bounds.position.y, internal_bounds.end.y)
	next_position_.x = clamp(next_position_.x, internal_bounds.position.x, internal_bounds.end.x)
	position = next_position_
