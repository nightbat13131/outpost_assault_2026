@tool
extends Node2D

@export var tile_nav : TileMapLayer_Directions
#var _last_direction : Vector2i

var _navigation_helper : NavigationLeg

func _ready() -> void:
	_navigation_helper = NavigationLeg.new()
	_navigation_helper.set_start(global_position)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 20, Color.BLACK)
	if !tile_nav:
		return
	var currnet_center = to_local( _navigation_helper.get_start_global_position() )
	#var currnet_center := to_local( tile_nav.get_current_cell_center_glob(global_position) )
	#draw_circle(
	#		currnet_center , 10, Color.RED
	#	)
	var next_center : Vector2
	var count := 60
	var width := 15.0
	while count > 0:
		tile_nav.update_leg(_navigation_helper)

		next_center = to_local( _navigation_helper.get_target_global_position())
		draw_line(currnet_center, next_center, Color.from_hsv(randf(), 1.0, 1.0), width)
		currnet_center = next_center
		_navigation_helper.set_start( to_global( currnet_center), _navigation_helper.get_direction())
		count -= 1
		width -= 2
