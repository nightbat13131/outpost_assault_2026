@tool
extends Node2D

@export var tilemap_d : TileMapLayer_Directions
var radian := PI
var second_point : Vector2

func _ready() -> void:
	if tilemap_d:
		global_position =  tilemap_d.to_global( tilemap_d.map_to_local(  tilemap_d.local_to_map(  tilemap_d.to_local(global_position) ) ) )
	_do_it.call_deferred()

func _do_it() -> void:
	
	if Engine.is_editor_hint():
		radian = tilemap_d._get_facing_direction(global_position)
	else:
		radian = TileMapLayer_Directions.get_facing_direction(global_position) # instance not set in engie
	queue_redraw()


func _draw() -> void:
	draw_line(
		Vector2.ZERO, 
		Vector2.from_angle(radian) *75 , #second_point, 
		Color.GREEN, 5
	)
