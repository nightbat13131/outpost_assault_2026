class_name Utilties extends GDScript

const COLOR_RADAR_PREVIEW = Color.BLACK
const COLOR_RADAR_FILL = Color.DARK_ORCHID


static func delta_radian(source_radian: float, target_radian: float) -> float:
	var _delta_radian : float = target_radian - source_radian
	if abs(_delta_radian) > PI:
		if _delta_radian > PI: 
			_delta_radian -= TAU
		else:
			_delta_radian += TAU
	return _delta_radian

static func reparent(child_node: Node2D, new_parent: Node2D) -> void:
	_reparent_defered.call_deferred(child_node, new_parent)

static func _reparent_defered(child_node: Node2D, new_parent: Node2D) -> void:
	var old_parent = child_node.get_parent()
	old_parent.remove_child(child_node)
	new_parent.add_child(child_node)


## currently assumes mirrored over x access
static func get_arch_points(radius: float, start_radian: float, point_count: int = 7, incldue_zero:= true) -> Array[Vector2]:
	var out : Array[Vector2] = []
	if incldue_zero:
		out.append(Vector2.ZERO)
	var current_radian = abs(start_radian)*-1
	var radian_delta = abs(start_radian) * 2.0 / point_count
	for index in range(point_count + 1):
		out.append(
			Vector2.from_angle(
				current_radian
			) * radius
		)
		current_radian += radian_delta
	return out
