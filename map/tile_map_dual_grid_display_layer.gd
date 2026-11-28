@tool
class_name TileMapDisplayLayer extends TileMapLayer_DualGrid
## curently writen for Squares 

@export var _dual_grid_logic :TileMapLogicLayer
var _atlas_tile_terrain : Dictionary[Vector2i, Array]
#var _cell_ground_types :  Dictionary[Vector2i, int]

@warning_ignore("unused_private_class_variable")
@export_tool_button("Refresh", "CanvasLayer") var _sync_logic = _logic_sync
@warning_ignore("unused_private_class_variable")
@export_tool_button("Printout", "PackedDataContainer") var _write_logic_ = _write_logic

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	#var tile_data : TileData
	#for cell in [Vector2i(-1,0), Vector2i.ZERO, Vector2i(1,0), Vector2i(2,0), Vector2i(3,0) ]:
	#	tile_data = get_cell_tile_data(cell)
	#	print("something", cell, tile_data)
	#_write_logic()
	#_place_tiles()

func _logic_sync() -> void:
	if _dual_grid_logic == null:
		push_warning("Display layer missing logic layer to sync with")
		return
	if ! tile_set_is_compatable(_dual_grid_logic):
		push_warning("Display layer has incompatalble tile_set")
		return
	position = _dual_grid_logic.position + ( Vector2( get_tile_set().get_tile_size()) * Vector2(.5,.5) )
	#queue_redraw()
	_place_tiles()

func _place_tiles() -> void:
	## might be changing to identical 
	if ! tile_set_is_compatable(_dual_grid_logic):
		return
	_clear_curent_display()
	var cell_ground : Array[int] = []
	var tile_data : TileData
	for cell in _dual_grid_logic.get_used_cells():
		cell_ground = []
		for _direction in [Vector2i(1,1), Vector2i(0,1), Vector2i(0,0), Vector2i(1,0),  ]:
			tile_data = _dual_grid_logic.get_cell_tile_data(cell+_direction)
			if tile_data != null:
				#cell_ground.append( tile_data.get_custom_data(DATA_LAYER_GROUND_TYPE) )
				cell_ground.append(tile_data.get_terrain())

		#print(cell_ground)
		if cell_ground.size() == 4: # has(TerrainTypes.NA):
			set_cell(cell, SOURCE_LAYER_DISPLAY, _get_atlas_cord(cell_ground), 0 )

func _get_atlas_cord(corners : Array[int]) -> Vector2i:
	var holder : Variant
	if _atlas_tile_terrain.is_empty():
		push_warning("No _atlas_tile_terrain mapped")
		return Vector2i(-1,-1)
	if corners.size() != 4:
		push_warning("corners has wrong number of elements")
		return Vector2i(-1,-1)
	holder = _atlas_tile_terrain.find_key(corners)
	if holder != null:
		return holder
	return Vector2i(-1,-1)

func _write_logic() -> void:
	print("a")
	var atlas_source : TileSetAtlasSource = get_tile_set().get_source(SOURCE_LAYER_DISPLAY)
	var atlas_cord : Vector2i
	var atlas_data : TileData
	var a_corners : Array[int]
	_atlas_tile_terrain.clear()
	for _x in atlas_source.get_atlas_grid_size().x:
		for _y in atlas_source.get_atlas_grid_size().y:
			atlas_cord = Vector2i(_x, _y)
			a_corners = []
			if atlas_source.has_tile(atlas_cord):
				#prints(atlas_cord)
				atlas_data = atlas_source.get_tile_data(atlas_cord, 0)
				for _corners in _SQUARE_CELLNCORNERS:
					atlas_data.get_terrain_peering_bit(_corners)
					a_corners.append(atlas_data.get_terrain_peering_bit(_corners))
						
				prints(atlas_cord, a_corners)
				_atlas_tile_terrain[atlas_cord] = a_corners
	print(_atlas_tile_terrain)

func _clear_curent_display() -> void:
	for cell in get_used_cells():
		set_cell(cell)

func _draw() -> void:
	draw_circle(map_to_local(Vector2i(-1,-1)), 30, Color.BLACK)
