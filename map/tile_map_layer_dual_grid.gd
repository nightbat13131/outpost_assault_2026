class_name TileMapLayer_DualGrid extends TileMapLayer
## Inspired by https://www.youtube.com/watch?v=jEWFSv3ivTg
## consider https://github.com/pablogila/TileMapDual

#const DATA_LAYER_GROUND_TYPE = &'DualGrid_GroundType'
const SOURCE_LAYER_LOGIC := 0
const SOURCE_LAYER_DISPLAY := 1

enum TerrainTypes {NA = 0, DIRT = 1, CONCRETE = 2, GRASS = 3, WATER = 4 }

const _SQUARE_CELLNCORNERS : Array[TileSet.CellNeighbor] = [
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER, 
	]

func tile_set_is_compatable(tile_map_layer: TileMapLayer) -> bool:
	if tile_map_layer == null: 
		return false
	var mine := get_tile_set()
	var yours := tile_map_layer.get_tile_set()
	if yours == null:
		return false
	return ( mine.get_tile_shape() == yours.get_tile_shape() ) and ( mine.get_tile_size() == yours.get_tile_size() )
