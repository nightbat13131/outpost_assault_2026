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
	var count := 3
	var width := 15.0
	while count > 0:
		tile_nav.update_leg(_navigation_helper)
		"""
		var next_direction : Vector2i = tile_nav.get_next_direction(global_position)
		print(next_direction)
		
		draw_line(
			currnet_center, currnet_center + ( Vector2( next_direction) * 100), Color.SEA_GREEN, 5
		)
		"""
		
		next_center = to_local( _navigation_helper.get_stop_global_position())
		draw_line(currnet_center, next_center, Color.from_hsv(randf(), 1.0, 1.0), width)
		currnet_center = next_center
		_navigation_helper.set_start( to_global( currnet_center), _navigation_helper.get_direction())
		count -= 1
		width -= 1
