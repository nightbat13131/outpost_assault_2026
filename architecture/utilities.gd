class_name Utilities extends GDScript

const COLOR_RADAR_PREVIEW = Color.BLACK
const COLOR_RADAR_FILL = Color.DARK_ORCHID

const PIX_PER_METTER = 128

static func try_divide(numerator: float,  denominator: float, alternate: float = 0) -> float:
	if is_equal_approx(denominator, 0.0):
		return alternate
	return numerator / denominator

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

## introduced by https://www.youtube.com/watch?v=PrCza2z0Log
static func property_dictionary(_name: String, _type: Variant.Type, _hint: PropertyHint, _hint_string: String = '' ) -> Dictionary:
	var out = {
		"name": _name, 
		"type": _type,
		"usage": PROPERTY_USAGE_DEFAULT, 
		"hint": _hint, 
	}
	if _hint_string != '':
		out["hint_string"] = _hint_string
	return out

static func pix_to_meter(pixel_count: float) -> float: return pixel_count / float(PIX_PER_METTER)
