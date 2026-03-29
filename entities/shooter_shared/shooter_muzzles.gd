class_name ShooterMuzzles extends Node
## get children is better than remembering positions because rotation moves the global positions

enum MuzzleOrder {SINGLE = 0, ALTERNATING = 1, ALL = 3}

var current_index := 0: 
	set(value):
		current_index = value % get_child_count()

func get_muzzle_locations(order: MuzzleOrder = MuzzleOrder.SINGLE) -> Array[Vector2]:
	match order:
		MuzzleOrder.ALTERNATING:
			return _get_muzzle_location_series()
		MuzzleOrder.ALL:
			return _get_all_muzzle_locations()
		_:
			return _get_muzzle_location()

func _get_muzzle_location(index := 0) -> Array[Vector2]:
	return [get_child(index).get_global_position()]

func _get_all_muzzle_locations() -> Array[Vector2]:
	var out : Array[Vector2]
	for each in get_children():
		out.append(each.get_global_position())
	return out

func _get_muzzle_location_series() -> Array[Vector2]:
	var out : Array[Vector2]
	out = _get_muzzle_location(current_index)
	current_index += 1
	return out
