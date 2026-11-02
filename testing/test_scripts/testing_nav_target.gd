extends Node

@export var unit: EnemyUnit
@export var directions: TileMapLayer_Directions

func _ready() -> void:
	if directions and unit:
		unit.set_tile_map_directions(directions)
