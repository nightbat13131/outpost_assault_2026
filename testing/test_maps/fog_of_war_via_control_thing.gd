@tool
extends GridContainer

func _ready() -> void:
	get_viewport().size_changed.connect(queue_redraw)

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
