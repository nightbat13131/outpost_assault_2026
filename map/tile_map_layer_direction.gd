@tool
class_name TileMapLayer_Directions
extends TileMapLayer

const DATA_LAYER_STOP = &'Stop'
const DATA_LAYER_CONTINUE = &'Continue'
const DATA_LAYER_OUTOING_DIRECTIONS = &'OutoingDirecitons'
const DATA_LAYER_OUTOING_ANGLES = &'OutgoingAngles'
const DATA_LAYER_OUTOING_CELLNEIGHBOR = &'OutgoingCellNeighbor'

@export var view_debug := false: 
	set(value):
		view_debug = value
		queue_redraw()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	set_modulate(Color(Color.WHITE, .5))

func get_shape() -> TileSet.TileShape: return get_tile_set().get_tile_shape()

func update_leg(leg: NavigationLeg) -> void:
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

func _draw() -> void:
	if view_debug:
		_debug_tile_config()

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
