@tool
class_name TileMapLayer_Directions
extends TileMapLayer

const DATA_LAYER_STOP = &'Stop'
const DATA_LAYER_CONTINUE = &'Continue'
const DATA_LAYER_OUTOING_DIRECTIONS = &'OutoingDirecitons'

## current pos, to center, next direction 

func get_current_cell_center_glob(global_pos: Vector2) -> Vector2:
	return to_global( map_to_local( local_to_map(to_local(global_pos))))

func get_next_direction(global_pos: Vector2, incomning_direction := Vector2.INF) -> Vector2:
	var cords := local_to_map(to_local(global_pos))
	var atlas := get_cell_atlas_coords(cords)
	return _get_next_direction( atlas, incomning_direction )

func update_leg(leg: NavigationLeg) -> void:
	var start_direction := leg.get_start_direction()
	if start_direction == Vector2.INF:
		_get_leg_on_track(leg)
		return
	var next_direction := start_direction
	var start_cord := local_to_map(to_local(leg.get_start_global_position()))
	#var atlas := get_cell_atlas_coords(start_cord)
	var current_cord := start_cord
	var tile_data : TileData
	var count := 3
	while count > 0 and next_direction == start_direction:
		tile_data = get_cell_tile_data(current_cord)
		if tile_data == null:
			prints("A no tile at cord", current_cord)
			next_direction = Vector2.ZERO
			break

		prints(count, current_cord,  tile_data.get_custom_data(DATA_LAYER_OUTOING_DIRECTIONS), tile_data.get_custom_data(DATA_LAYER_CONTINUE), tile_data.get_custom_data(DATA_LAYER_STOP) )
		next_direction = _get_next_direction(current_cord, start_direction)
		#atlas = get_cell_atlas_coords(current_cord)
		#if atlas != CONTINUE:
		#	break
		current_cord += Vector2i(next_direction)
		start_direction = next_direction
		count -= 1
	leg.set_destination( to_global( map_to_local(current_cord) ), next_direction )

func _get_leg_on_track(leg: NavigationLeg) -> void:
	var start :=  leg.get_start_global_position()
	var cell_center := get_current_cell_center_glob(start)
	leg.set_destination(
		cell_center, (start - cell_center).normalized()
	)

func _get_next_direction(cord: Vector2i, incomning_direction := Vector2.INF) -> Vector2:
	var tile_data : TileData = get_cell_tile_data(cord)
	if tile_data == null:
		prints("B no tile at cord", cord)
		return Vector2.ZERO
	var options : Array[Vector2] = []
	for each in tile_data.get_custom_data(DATA_LAYER_OUTOING_DIRECTIONS): ## allows for typed Array
		if each is Vector2:
			options.append(each)
	
	if options.is_empty():
		return incomning_direction
	elif options.size() == 1:
		return options[0]
	while options.has(incomning_direction):
			options.erase(incomning_direction)
	return options.pick_random()
