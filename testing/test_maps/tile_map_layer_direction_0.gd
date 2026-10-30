@tool
class_name TileMapLayer_Directions0
extends TileMapLayer

#region Atlas Constants
const CONTINUE = Vector2i(0,1)
const STOP = Vector2i(0,3)
const NSEW_ANY = Vector2i(0,2)
const NSEW_CONTINUE= Vector2i(1,2)

const N = Vector2i(0,0)
const S = Vector2i(1,0)
const E = Vector2i(2,0)
const W = Vector2i(3,0)

const NS = Vector2i(1,1)
const NE = Vector2i(2,1)
const NW = Vector2i(3,2)

const SE = Vector2i(2,2)
const SW = Vector2i(3,2)

const EW = Vector2i(3,3)
const SEW = Vector2i(0,4)
const NEW = Vector2i(1,4)
const NSW = Vector2i(2,4)
const NSE = Vector2i(3,4)

const NNS = Vector2i(1,5)
const NNE = Vector2i(2,5)
const NNW = Vector2i(3,4)

const NSS = Vector2i(0,6)
const SSE = Vector2i(2,6)
const SSW = Vector2i(3,6)

const NEE = Vector2i(0,7)
const SEE = Vector2i(1,7)
const EEW = Vector2i(3,7)

const NWW = Vector2i(0,8)
const SWW = Vector2i(1,8)
const EWW = Vector2i(3,8)
#endregion

## current pos, to center, next direction 

func get_current_cell_center_glob(global_pos: Vector2) -> Vector2:
	return to_global( map_to_local( local_to_map(to_local(global_pos))))

func get_next_direction(global_pos: Vector2, incomning_direction := Vector2.INF) -> Vector2:
	var cords := local_to_map(to_local(global_pos))
	var atlas := get_cell_atlas_coords(cords)
	return _get_next_direction( atlas, incomning_direction )

func update_leg(leg: NavigationLeg) -> void:
	var direction := get_next_direction(leg.get_start_global_position(), leg.get_start_direction())
	var start_cord := local_to_map(to_local(leg.get_start_global_position()))
	var atlas := get_cell_atlas_coords(start_cord)
	var current_cord := start_cord
	var count := 20
	while count > 0:
		current_cord += Vector2i(direction)
		atlas = get_cell_atlas_coords(current_cord)
		if atlas != CONTINUE:
			break
		count -= 1
	leg.set_destination( to_global( map_to_local(current_cord) ) )

func get_next_pos(start_pos: Vector2) -> Vector2:
	return Vector2(0, 0)

func _get_next_direction(atlas: Vector2i, incomning_direction := Vector2.INF) -> Vector2i:
	
	if atlas == CONTINUE:
		return incomning_direction
	match atlas: 
		N:
			return Vector2i.UP
		S:
			return Vector2i.DOWN
		E: 
			return Vector2i.RIGHT
		W:
			return Vector2i.LEFT
	var options : Array[Vector2i] = []
	
	if [NSEW_ANY, NSEW_CONTINUE, NS, NE, NW, NEW, NSW, NSE, NNS, NNE, NNW, NSS, NEE, NWW].has(atlas): # N
		options.append(Vector2i.UP)
		if [NNE, NNS, NNW].has(atlas):
			options.append(Vector2.UP)
	if [NSEW_ANY, NSEW_CONTINUE, NS, SE, SW, SEW, NSW, NSE, NNS, NSS, SSE, SSW, SEE, SWW].has(atlas): # S
		options.append(Vector2i.DOWN)
		if [SSE, NSS, SSW].has(atlas):
			options.append(Vector2.UP)
	if [NSEW_ANY, NSEW_CONTINUE, NE, SE, EW, SEW, NEW, NSE, NNE, SSE, NEE, SEE, EEW, EWW].has(atlas): # E
		options.append(Vector2i.RIGHT)
		if [EEW, NEE, SEE].has(atlas):
			options.append(Vector2i.RIGHT)
	if [NSEW_ANY, NSEW_CONTINUE, NW, SW, EW, SEW, NEW, NSW, NNW, SSW, EEW, NWW, SSW, EWW].has(atlas): # W
		options.append(Vector2i.LEFT)
		if [EWW, NWW, SWW].has(atlas):
			options.append(Vector2i.LEFT)
	
	if atlas == NSEW_CONTINUE:
		while options.has(incomning_direction):
			options.erase(incomning_direction)
	return options.pick_random()
