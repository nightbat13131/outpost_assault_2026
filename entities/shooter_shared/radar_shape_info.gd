@tool
class_name RadarShapeInfo extends Resource

signal shape_changed
signal poly_changed

enum TargetShape {NA = 0, CIRCLE_FILLED = 1, ARCH_FILLED = 2}

@export var _radar_shape := TargetShape.NA: set = set_shape

var _shapes : Array[Shape3D] : get= get_shapes
var _polygons : Array[PackedVector2Array] : get = get_polygons

var _outer_radius := 100.0 : set = set_outer_radius, get = get_outer_radius
var _inner_radius := 75.0 : set = set_inner_radius

## When the target shape is an arch, what is the starting degree of that arch
var _arch_degrees := 45.0 : set = set_arch_degrees, get = get_arch_degrees

func has_shapes() -> bool: return !_shapes.is_empty()
func has_polygons() -> bool: return !_polygons.is_empty()

func set_outer_radius(value: float) -> void: 
	_outer_radius = value
	_refresh_shapes_details()

func get_outer_radius() -> float: return _outer_radius

func set_inner_radius(value: float) -> void: 
	_inner_radius = value
	_refresh_shapes_details()

func set_shape(shape: TargetShape) -> void:
	if _radar_shape == shape and (!_shapes.is_empty() or !_polygons.is_empty()) :
		return # no change
	_radar_shape = shape
	_setup_shape_arrays()
	shape_changed.emit()
	notify_property_list_changed()

func set_arch_degrees(degrees: float) -> void : 
	_arch_degrees = degrees
	_refresh_shapes_details()

func get_arch_degrees() -> float: return _arch_degrees

func replicate(recipiant: RadarShapeInfo) -> void:
	recipiant.set_outer_radius(get_outer_radius())
	recipiant.set_inner_radius(_inner_radius)
	recipiant.set_arch_degrees(get_arch_degrees())
	recipiant.set_shape(_radar_shape)

func get_shapes() -> Array[Shape3D]: return _shapes

func get_polygons() -> Array[PackedVector2Array]: return _polygons

func _setup_shape_arrays() -> void:
	_polygons = []
	_shapes = []
	match _radar_shape:
		TargetShape.NA:
			return
		TargetShape.CIRCLE_FILLED:
			_shapes.append(CylinderShape3D.new())
		TargetShape.ARCH_FILLED:
			_polygons.append([])
	_refresh_shapes_details()

func _refresh_shapes_details() -> void:
	if _radar_shape == TargetShape.NA:
		return
	if !(has_polygons() or has_shapes()):
		_setup_shape_arrays()
		return
	# assuming that _setup_shape_arrays has the correct shaped in the arrays
	match _radar_shape:
		RadarShapeInfo.TargetShape.CIRCLE_FILLED:
			_shapes[0].set_radius(get_outer_radius())
		RadarShapeInfo.TargetShape.ARCH_FILLED:
			_polygons[0] = Utilities.get_arch_points(get_outer_radius(), deg_to_rad(get_arch_degrees())*.5)
			poly_changed.emit()
	changed.emit()

func draw(node: Node2D) -> void:
	# outline
	match _radar_shape:
		TargetShape.CIRCLE_FILLED:
			_draw_circle_filled(node)
		TargetShape.ARCH_FILLED:
			_draw_single_poly(node)

func _draw_circle_filled(node: Node2D) -> void:
	node.draw_circle(
		Vector2.ZERO, 
		_outer_radius,
		Utilities.COLOR_RADAR_PREVIEW, 
		false,
		5.0
	)

func _draw_single_poly(node: Node2D) -> void:
	var points = get_polygons()[0]
	points.append(points[0])
	node.draw_polyline(
		points, 
		Utilities.COLOR_RADAR_PREVIEW, 
		5.0
	)

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	if [TargetShape.ARCH_FILLED].has(_radar_shape):
		properties.append(
			Utilities.property_dictionary("_arch_degrees", TYPE_FLOAT, PROPERTY_HINT_NONE, ""))
	return properties

func _property_can_revert(property: StringName) -> bool:
	return property == "_arch_degrees"

func _property_get_revert(property: StringName) -> Variant:
	if property == "_arch_degrees":
		return 45.0
	return null
