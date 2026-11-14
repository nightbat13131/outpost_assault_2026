class_name TileMapLogicLayer extends TileMapLayer
## Inspired by https://www.youtube.com/watch?v=jEWFSv3ivTg
## consider https://github.com/pablogila/TileMapDual

## values in the provided tilemap will overwrite upload ready
@export var _overwrite_tile_map : TileMapLayer

enum GroundTypes {NA = 0, DIRT = 10, CONCRETE = 11, GRASS = 20, WATER = 30 }


func _ready() -> void:
	if _overwrite_tile_map:
		apply_overlay(_overwrite_tile_map)

func apply_overlay(_over : TileMapLayer) -> void:
	if _over: 
	# take the tiles used in _over and set them in _real
		if get_tile_set() != _over.get_tile_set():
			push_warning("overwrite TileMap does not have the matching TileSet")
			return
		var atlas : Vector2i
		for target_cell in _over.get_used_cells():
			atlas = _over.get_cell_atlas_coords(target_cell)
			set_cell(target_cell, 0, atlas)
			_over.set_cell(target_cell)
