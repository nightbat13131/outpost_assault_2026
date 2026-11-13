@tool
class_name TileMapLayer_Directions
extends TileMapLayer

static var _instance : TileMapLayer_Directions

const ATLAS_TARGET : Vector2i = Vector2i(0,2)
const DATA_LAYER_STOP = &'Stop'
const DATA_LAYER_CONTINUE = &'Continue'
const DATA_LAYER_OUTOING_DIRECTIONS = &'OutoingDirecitons'
const DATA_LAYER_OUTOING_ANGLES = &'OutgoingAngles'
const DATA_LAYER_OUTOING_CELLNEIGHBOR = &'OutgoingCellNeighbor'

## https://github.com/godotengine/godot/blob/ed1daf0bf001b61586d9930840f2f1394092c079/scene/resources/2d/tile_set.cpp#L2114
const _SQUARE_CELLNEIGHBORS : Array[TileSet.CellNeighbor] = [
	TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE,
	TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER,
	TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE,
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_CORNER,
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE, 
	TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_CORNER, 
	]

const _HORIZONTAL_OFFSET_DIRECTIONS : Array[TileSet.CellNeighbor] = [
			TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_SIDE,
	]

const _VERTICAL_OFFSET_DIRECTIONS : Array[TileSet.CellNeighbor] = [
			TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_RIGHT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_LEFT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_LEFT_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_SIDE,
			TileSet.CellNeighbor.CELL_NEIGHBOR_TOP_RIGHT_SIDE,
	]

@export var view_debug := false: 
	set(value):
		view_debug = value
		queue_redraw()


## Cord : Distance 
var _path_distances: Dictionary[Vector2i, float] = {}

func _init() -> void:
	_instance = self

func _ready() -> void:
	_calculate_distnaces_no_direction()
	if Engine.is_editor_hint():
		return
	set_modulate(Color(Color.WHITE, .5))

static func get_intsance() -> TileMapLayer_Directions: return _instance

#region Distance from target


func _calculate_distnaces_no_direction() -> void:
	var _focus_cell : Vector2i = _find_target_cell()
	if _focus_cell == Vector2i.MAX: # no target
		return
	var _focus_value := -1.0
	_path_distances.set(_focus_cell, _focus_value)
	#var _value_n := INF
	var _new_value := INF
	var _atlas := Vector2i.MAX
	var _next_cells : Array[Vector2i] = [_focus_cell ] #get_surrounding_cells(_focus_cell)
	#var _neighbors : Array[Vector2i] = []
	var limit := 1000000
	while !_next_cells.is_empty() and limit > 0:
		limit -= 1
		_focus_cell = _next_cells.pop_front()
		_atlas = get_cell_atlas_coords(_focus_cell) 
		if get_cell_atlas_coords(_focus_cell) == Vector2i(-1,-1):  #no path at this location
			continue
		elif _atlas == ATLAS_TARGET:
			_focus_value = -1
		else:
			_focus_value = _path_distances.get(_focus_cell, INF)
			
		_new_value = INF
		#_neighbors = []
		for n_cell in get_surrounding_cells(_focus_cell):
			if get_cell_atlas_coords( n_cell ) != Vector2i(-1,-1): # path found at cell
				#_neighbors.append(n_each) 
				
				if _path_distances.get(n_cell, INF) + 1 < _new_value:
					_new_value = _path_distances.get(n_cell, INF) + 1
				else:
					if !_next_cells.has(n_cell):
						_next_cells.append(n_cell)

		if _path_distances.get(_focus_cell, INF) > _new_value: 
			_path_distances.set(_focus_cell, _new_value)
			#for each_n in _neighbors:
			

	print(_next_cells)
	print(limit)
	print(_path_distances)

func _find_target_cell() -> Vector2i:
	for each_cell in get_used_cells():
		if get_cell_atlas_coords(each_cell) == ATLAS_TARGET:
			return each_cell
	return Vector2i.MAX

#endregion



#region Angle pointing at most paths

func get_shape() -> TileSet.TileShape: return get_tile_set().get_tile_shape()

func get_offset() -> TileSet.TileOffsetAxis: return get_tile_set().get_tile_offset_axis()

## Given the position of a tower, what direction should it face to cover the most path.
## If the value is greater than TAU*2, then the value is random.
static func get_facing_direction(pos_global: Vector2) -> float:
	if get_intsance():
		return get_intsance()._get_facing_direction(pos_global)
	return randf_range(0.0, TAU) + TAU * 3

func _get_facing_direction(pos_global: Vector2) -> float:
	var local_focus := to_local(pos_global)
	var focus_cord := local_to_map( local_focus )
	var _cell_neighbors = _SQUARE_CELLNEIGHBORS
	if get_shape() == TileSet.TileShape.TILE_SHAPE_HEXAGON:
		if get_offset() == TileSet.TileOffsetAxis.TILE_OFFSET_AXIS_HORIZONTAL:
			_cell_neighbors = _HORIZONTAL_OFFSET_DIRECTIONS
		else:
			_cell_neighbors = _VERTICAL_OFFSET_DIRECTIONS
	var neighbor_cell : Vector2i
	var second_point := Vector2.ZERO
	var data : TileData # debug
	for direction in _cell_neighbors:
		neighbor_cell = get_neighbor_cell(focus_cord, direction)
		data = get_cell_tile_data(neighbor_cell)
		if data: 
			# might add some kind of weighting in the future
			second_point += (  map_to_local(neighbor_cell) - local_focus ) 
	if second_point == Vector2.ZERO:
		return randf_range(0.0, TAU) + TAU * 3
	return second_point.angle()
#endregion


#region Leg Navigation

static func update_leg(leg: NavigationLeg) -> void:
	if get_intsance():
		get_intsance()._update_leg(leg)

func _update_leg(leg: NavigationLeg) -> void:
	var incoming_direction := invert_direction( leg.get_start_direction() )
	if incoming_direction == Utilities.DIRECTION_INIT:
		_get_leg_on_track(leg)
		return
	var starting_cord := local_to_map(to_local(leg.get_start_global_position()))
	var outgoing_direction :int = _get_next_direction(starting_cord, incoming_direction)
	if outgoing_direction == Utilities.DIRECTION_STOP:
		leg.set_destination( to_global( map_to_local(starting_cord)), outgoing_direction)
		return
	if outgoing_direction < 0 or outgoing_direction > 15:
		prints("outgoing direction not expected", starting_cord, outgoing_direction)
	var target_cord := get_neighbor_cell(starting_cord, outgoing_direction)
	var target_data := get_cell_tile_data(target_cord)
	var limit := 10
	while _is_continue_no_turn(target_data) and limit > 0:
		target_cord = get_neighbor_cell(target_cord, outgoing_direction)
		target_data = get_cell_tile_data(target_cord)
		limit -= 1
	leg.set_destination( to_global( map_to_local(target_cord) ), outgoing_direction )

func _get_next_direction(start_cords: Vector2i, incomning_direction := Utilities.DIRECTION_INIT) -> int:
	var tile_data : TileData = get_cell_tile_data(start_cords)
	if _is_stop(tile_data):
		return Utilities.DIRECTION_STOP
	if tile_data == null:
		prints("B no tile at cord", start_cords)
		return Utilities.DIRECTION_STOP
	var options := _get_posible_diretions(tile_data)
	if options.is_empty():
		return incomning_direction
	elif options.size() == 1:
		return options[0]
	while options.has(incomning_direction) and options.size() > 1:
			options.erase(incomning_direction)
	return options.pick_random()

func _is_stop(tile_data: TileData) -> bool:
	if tile_data == null:
		return true
	var out = tile_data.get_custom_data(DATA_LAYER_STOP)
	if out is bool:
		return out
	return false

func _is_continue_no_turn(tile_data: TileData) -> bool:
	if tile_data == null: 
		return false
	if _is_stop(tile_data):
		return false
	if tile_data.get_custom_data(DATA_LAYER_CONTINUE):
		return _get_posible_diretions(tile_data).is_empty()
	return false

func _get_posible_diretions(tile_data: TileData) -> Array[int]:
	assert(tile_data)
	var options : Array[int] = []
	if tile_data == null:
		return options
	for each in tile_data.get_custom_data(DATA_LAYER_OUTOING_CELLNEIGHBOR): ## allows for typed Array
		if each is int:
			options.append(each)
	return options

func _get_leg_on_track(leg: NavigationLeg) -> void:
	var start_pos_g :=  leg.get_start_global_position()
	var cell_center := to_global( map_to_local(  local_to_map( to_local(start_pos_g) ) ) )
	leg.set_destination(cell_center, Utilities.DIRECTION_UKNOWN )

func invert_direction(orignal_direction := Utilities.DIRECTION_UKNOWN ) -> int:
	if orignal_direction < 0: 
		return orignal_direction
	if orignal_direction >= 8:
		return orignal_direction - 8
	return orignal_direction + 8
#endregion

func _draw() -> void:
	if view_debug:
		#_debug_tile_config()
		_debug_distance()

func _debug_distance() -> void:
	var center := Vector2.ZERO
	var angle : float
	for cell in _path_distances.keys():
		center = map_to_local(cell)
		angle = _path_distances.get(cell)
		
		draw_line(center, center + Vector2.from_angle(deg_to_rad( angle * 7) ) * angle * 2, Color.CADET_BLUE, 10)
	pass

func _debug_tile_config() -> void:
	var color : Color
	var center : Vector2
	var tile_data : TileData
	var radius : float
	for each_cord in get_used_cells():
		color = Utilities.get_random_color()
		center = map_to_local(each_cord)
		tile_data = get_cell_tile_data(each_cord)
		if tile_data == null:
			prints("Tile data missing from cord ", each_cord)
		draw_circle(center, 5, color, true) 
		if tile_data:
			if tile_data.get_custom_data(DATA_LAYER_CONTINUE) == true:
				radius = 30
			else: 
				radius = 10
			draw_circle(center, radius, color, false, 2) 
			if tile_data.get_custom_data(DATA_LAYER_STOP):
				draw_polygon(
					[center+Vector2(1,1)*radius, center+Vector2(1,-1)*radius, center+Vector2(-1,-1)*radius, center+Vector2(-1,1)*radius], [Color.BLACK])
			for each_neighbor : int in tile_data.get_custom_data(DATA_LAYER_OUTOING_CELLNEIGHBOR): 
				center += Vector2.ONE * 5
				draw_line(
					center, map_to_local( get_neighbor_cell(each_cord, each_neighbor) ), color, 3
				)
