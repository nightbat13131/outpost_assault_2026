@tool
class_name TileMapLayer_Directions1
extends TileMapLayer

const DATA_LAYER_STOP = &'Stop'
const DATA_LAYER_CONTINUE = &'Continue'
const DATA_LAYER_OUTOING_DIRECTIONS = &'OutoingDirecitons'
const DATA_LAYER_OUTOING_ANGLES = &'OutgoingAngles'
const DATA_LAYER_OUTOING_CELLNEIGHBOR = &'OutgoingCellNeighbor'

@export var is_hex := false
@export var view_debug := false: 
	set(value):
		view_debug = value
		queue_redraw()

@onready var _tile_size : Vector2i = get_tile_set().get_tile_size()

func get_current_cell_center_glob(global_pos: Vector2) -> Vector2:
	return to_global( map_to_local( local_to_map(to_local(global_pos))))

func get_next_direction(global_pos: Vector2, incomning_direction := Vector2.INF) -> Vector2:
	var cords := local_to_map(to_local(global_pos))
	var atlas := get_cell_atlas_coords(cords)
	return _get_next_direction( atlas, incomning_direction )

func update_leg(leg: NavigationLeg) -> void:
	var incoming_direction := leg.get_start_direction()
	if incoming_direction == Vector2.INF:
		_get_leg_on_track(leg)
		return
	var starting_cord := local_to_map(to_local(leg.get_start_global_position()))
	var outgoing_direction :Vector2i = _get_next_direction(starting_cord, incoming_direction)
	var target_cord := starting_cord +  outgoing_direction
	var target_data := get_cell_tile_data(target_cord)
	var limit := 10
	while _is_continue_no_turn(target_data) and limit > 0:
		target_cord += outgoing_direction
		target_data = get_cell_tile_data(target_cord)
		limit -= 1
	leg.set_destination( to_global( map_to_local(target_cord) ), outgoing_direction )


func _is_stop(tile_data: TileData) -> bool:
	if tile_data == null:
		return true
	return bool(tile_data.get_custom_data(DATA_LAYER_STOP))

func _is_continue_no_turn(tile_data: TileData) -> bool:
	if tile_data == null: 
		return false
	if _is_stop(tile_data):
		return false
	if tile_data.get_custom_data(DATA_LAYER_CONTINUE):
		return _get_posible_diretions(tile_data).is_empty()
	return false

func _get_posible_diretions(tile_data: TileData) -> Array[Vector2]:
	assert(tile_data)
	var options : Array[Vector2] = []
	for each in tile_data.get_custom_data(DATA_LAYER_OUTOING_DIRECTIONS): ## allows for typed Array
		if each is Vector2:
			options.append(each)
	return options

func _get_posible_diretions_degrees(tile_data: TileData) -> Array[float]:
	assert(tile_data)
	var options : Array[float] = []
	for each in tile_data.get_custom_data(DATA_LAYER_OUTOING_ANGLES): ## allows for typed Array
		if each is float:
			options.append(each)
	return options

func _get_leg_on_track(leg: NavigationLeg) -> void:
	var start_pos_g :=  leg.get_start_global_position()
	var cell_center := get_current_cell_center_glob(start_pos_g)
	leg.set_destination(
		cell_center,
		# Vector2.ZERO
		# [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
		(start_pos_g - cell_center).normalized()
	)

func _get_next_direction(cord: Vector2i, incomning_direction := Vector2.INF) -> Vector2:
	incomning_direction *= -1
	var tile_data : TileData = get_cell_tile_data(cord)
	if _is_stop(tile_data):
		return Vector2.ZERO
	if tile_data == null:
		prints("B no tile at cord", cord)
		return Vector2.ZERO
	var options := _get_posible_diretions(tile_data)
	if options.is_empty():
		return incomning_direction
	elif options.size() == 1:
		return options[0]
		
	while options.has(incomning_direction):
			options.erase(incomning_direction)
	return options.pick_random()

func _get_cords_in_direction(start_cord: Vector2i, radian: float) -> Vector2i:
	var _position = map_to_local(start_cord)
	_position += (Vector2.from_angle(radian) * Vector2( _tile_size ) )
	return local_to_map(_position)

func _get_local_center_in_direction(start_cord: Vector2i, radian: float) -> Vector2:
	var _position = map_to_local(start_cord)
	_position += (Vector2.from_angle(radian) * Vector2( _tile_size ) )
	return _position

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
			for each_direction in tile_data.get_custom_data(DATA_LAYER_OUTOING_DIRECTIONS):
				center += Vector2.ONE * 5
				draw_line(
					center, center + each_direction * 65, color, 3
				)

func _draw_angle_directions() -> void:
	pass
