@tool
class_name CameraBounds extends Resource

@export var rect_position := Vector2.ZERO:
	set(value):
		rect_position = value
		_limit_rect.position = rect_position
@export var rect_size := Vector2(900,1200): 
	set(value):
		rect_size = value
		_limit_rect.size = rect_size
@export var camera_start : Vector2

var _limit_rect : Rect2 : get = get_limit_rect

func get_limit_rect() -> Rect2:
	if !Engine.is_editor_hint():
		if camera_start == Vector2.ZERO:
			camera_start = rect_position + rect_size*.5
	return Rect2(rect_position, rect_size)
	

func draw_bounds(node: Node2D, color: Color = Color.RED) -> void:
	#node.draw_line(rect_position, get_limit_rect().end, color, 2.0)
	node.draw_polyline([
		_limit_rect.position, Vector2(_limit_rect.end.x, _limit_rect.position.y), 
		_limit_rect.end, Vector2(_limit_rect.position.x, _limit_rect.end.y), 
		_limit_rect.position], color, 2)
	node.draw_line(camera_start + Vector2(1,1)*50, camera_start + Vector2(-1,-1)*50, color, 10.0)
	node.draw_line(camera_start + Vector2(1,-1)*50, camera_start + Vector2(-1,1)*50, color, 10.0)

func get_camera_starting_position() -> Vector2: 
	return camera_start
