@tool
class_name TileMapDisplayLayer extends TileMapLayer_DualGrid
## curently writen for Squares 

@export var _dual_grid_logic :TileMapLogicLayer

@export_tool_button("Refresh", "CanvasLayer") var _sync_logic = _logic_sync

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	var tile_data : TileData
	for cell in [Vector2i(-1,0), Vector2i.ZERO, Vector2i(1,0), Vector2i(2,0), Vector2i(3,0) ]:
		tile_data = get_cell_tile_data(cell)
		print("something", cell, tile_data)
		

func _logic_sync() -> void:
	if _sync_logic: pass # prevent unused variable warnings 
	if _dual_grid_logic == null:
		push_warning("Display layer missing logic layer to sync with")
		return
	if ! tile_set_is_compatable(_dual_grid_logic):
		push_warning("Display layer has incompatalble tile_set")
		return
	position = _dual_grid_logic.position - ( get_tile_set().get_tile_size() * .5 )
	#queue_redraw()
	_place_tiles()

func _place_tiles() -> void:
	if ! tile_set_is_compatable(_dual_grid_logic):
		return
	#var logic_tile_set := _dual_grid_logic.get_tile_set()
	var cell_ground : Array[GroundTypes] = []
	#var atlas_cord : Vector2i
	var tile_data : TileData
	
	for cell in _dual_grid_logic.get_used_cells():
		cell_ground = []
		for _direction in [Vector2i.ZERO, Vector2i(1,0), Vector2i(1,-1), Vector2i(0,-1) ]:
			tile_data = _dual_grid_logic.get_cell_tile_data(cell+_direction)
			if tile_data == null:
				cell_ground.append(GroundTypes.NA)
			else:
				cell_ground.append( tile_data.get_custom_data(DATA_LAYER_GROUND_TYPE) )
		print(cell_ground)
		if !cell_ground.has(GroundTypes.NA):
			
			set_cell(cell, 0, Vector2.ZERO)
			
