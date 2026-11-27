@tool
class_name FogOfWar extends GridContainer

static var _instance : FogOfWar

func _init() -> void: 
	_instance = self
	tree_exiting.connect(_on_exiting_tree)

func _ready() -> void:
	get_viewport().size_changed.connect(queue_redraw)

func apply_bounds(camera_bounds: CameraBounds) -> void:
	position = camera_bounds.get_limit_rect().position
	size = camera_bounds.get_limit_rect().size

func _draw() -> void:
	var v_size := get_viewport_rect().size
	var s_size := size
	var n : float = v_size.y*-1
	var s : float = v_size.y + s_size.y
	var e : float = v_size.x+s_size.x
	var w : float = v_size.x*-1+0
	draw_polygon(
		[Vector2(w, n), Vector2(e, n), Vector2(e, 0), Vector2(w, 0)], 
		[Color.BLACK]
	)
	draw_polygon(
		[Vector2(w, n), Vector2(0, n), Vector2(0, s), Vector2(w, s)], 
		[Color.BLACK]
	)
	draw_polygon(
		[Vector2(s_size.x, n), Vector2(e, n), Vector2(e, s), Vector2(s_size.x, s)], 
		[Color.BLACK]
	)
	draw_polygon(
		[Vector2(w, s_size.y), Vector2(e, s_size.y), Vector2(e, s), Vector2(w, s)], 
		[Color.BLACK]
	)
	#draw_polyline([Vector2(w,n), Vector2(e, n), Vector2(e,s), Vector2(w,s)], Color.ORANGE)


func _is_within_game_view(global_pos: Vector2) -> bool:
	return Rect2(position, size).has_point(get_parent().to_local(global_pos) )

func _on_exiting_tree() -> void: _instance = null

static func has_instance() -> bool: return _instance != null

static func get_instance() -> FogOfWar: return _instance

static func is_within_game_view(global_pos: Vector2) -> bool:
	if has_instance():
		return get_instance()._is_within_game_view(global_pos)
	return true
