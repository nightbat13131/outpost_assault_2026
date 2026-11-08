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
	if tilemap_d:
		global_position =  tilemap_d.to_global( tilemap_d.map_to_local(  tilemap_d.local_to_map(  tilemap_d.to_local(global_position) ) ) )
		_do_it.call_deferred()

func _do_it() -> void:
	radian = tilemap_d.get_facing_direction(global_position)
	queue_redraw()
	return


func _draw() -> void:
	#draw_line(
		#Vector2.ZERO, Vector2.from_angle(radian) * 100, Color.RED, 5
	#)
	draw_line(
		Vector2.ZERO, 
		Vector2.from_angle(radian) *75 , #second_point, 
		Color.GREEN, 5
	)
