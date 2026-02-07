@tool
class_name CameraBounds extends Resource

@export var rect_position := Vector2.ZERO
@export var rect_size := Vector2(900,1200)
@export var starting_location := Vector2.ZERO

var _limit_rect : Rect2 : get = get_limit_rect

func get_limit_rect() -> Rect2:
	if !Engine.is_editor_hint():
		if starting_location == Vector2.ZERO:
			starting_location = rect_position + rect_size*.5
	if _limit_rect.size == Vector2.ZERO:
		_limit_rect = Rect2(rect_position, rect_size)
	return _limit_rect

func draw_bounds(node: Node2D, color: Color = Color.RED) -> void:
	node.draw_line(rect_position, get_limit_rect().end, color, 2.0)
	node.draw_line(starting_location + Vector2(1,1)*50, starting_location + Vector2(1,1)*-50, color, 4.0)
	node.draw_line(starting_location + Vector2(1,-1)*50, starting_location + Vector2(-1,1)*-50, color, 4.0)

func apply_to_camera(camera: Camera2DEnhanced) -> void:
	# zoom
	var screen = camera.get_viewport_rect().size
	var limit_size = _limit_rect.size * .95
	if limit_size.x > limit_size.y:
		camera.set_min_zoom(screen.x / limit_size.x)
	else:
		camera.set_min_zoom(screen.y / limit_size.y)
	camera.set_limits(get_limit_rect())
	camera.remote_move_to(rect_position + rect_size*.5)
	camera.queue_redraw()
