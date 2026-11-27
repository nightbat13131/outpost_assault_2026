class_name TileMapLayer_DualGrid extends TileMapLayer
## Inspired by https://www.youtube.com/watch?v=jEWFSv3ivTg
## consider https://github.com/pablogila/TileMapDual

const DATA_LAYER_GROUND_TYPE = &'DualGrid_GroundType'

enum GroundTypes {NA = 0, DIRT = 10, CONCRETE = 11, GRASS = 20, WATER = 30 }
static var ground_types_map_terains : Dictionary[GroundTypes, int] = {
	GroundTypes.DIRT : 0, 
	GroundTypes.CONCRETE : 1
}

func tile_set_is_compatable(tile_map_layer: TileMapLayer) -> bool:
	if tile_map_layer == null: 
		return false
	var mine := get_tile_set()
	var yours := tile_map_layer.get_tile_set()
	if yours == null:
		return false
	return ( mine.get_tile_shape() == yours.get_tile_shape() ) and ( mine.get_tile_size() == yours.get_tile_size() )
