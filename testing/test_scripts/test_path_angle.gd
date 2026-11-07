@tool
extends Node2D

@export var tilemap_d : TileMapLayer_Directions
var radian := PI
var second_point : Vector2

var _square_directions : Array[TileSet.CellNeighbor] = [
	TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE,
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER, 
	]

func _ready() -> void:
	_do_it.call_deferred()

func _do_it() -> void:
	var tilemap_local := tilemap_d.to_local(global_position)
	var tilemap_cord := tilemap_d.local_to_map(tilemap_local)
	#print( tilemap_d.get_surrounding_cells(tilemap_cord))
	var _directions = _square_directions
	var things : Array
	var neighbor_cell : Vector2i
	for direction in _directions:
		neighbor_cell = tilemap_d.get_neighbor_cell(tilemap_cord, direction)
		if tilemap_d.get_cell_tile_data(neighbor_cell): 
			
			things.append( tilemap_d.to_global( tilemap_d.map_to_local(neighbor_cell) ) )
	var count := 1
	for each in things:
		second_point += to_local( each )
		count += 1
	second_point /= count
	second_point += Vector2(10,10)
	second_point = second_point.normalized()
	second_point *= 100

	prints(things, second_point)
	queue_redraw()

func _draw() -> void:
	draw_line(
		Vector2.ZERO, Vector2.from_angle(radian) * 100, Color.RED, 5
	)
	draw_line(
		Vector2.ZERO, second_point, Color.GREEN, 5
	)
