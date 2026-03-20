class_name ShooterMuzzles extends Node
## get children is better than remembering because rotation moves the global positions

var current_index := 0: 
	set(value):
		current_index = value % get_child_count()

func get_muzzle_location(index := 0) -> Array[Vector2]:
	return [get_child(index).get_global_position()]

func get_all_muzzle_locations() -> Array[Vector2]:
	var out : Array[Vector2]
	for each in get_children():
		out.append(each.get_global_position())
	return out

func get_muzzle_location_series() -> Array[Vector2]:
	var out : Array[Vector2]
	out = get_muzzle_location(current_index)
	current_index += 1
	return out
