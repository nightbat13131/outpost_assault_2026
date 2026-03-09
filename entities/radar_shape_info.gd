class_name RadarShapeInfo extends Resource

enum TargetShape {NA = 0, CIRCLE_FILLED = 1, ARCH_FILLED = 2}

@export var _radar_shape := TargetShape.NA

var _shapes : Array[Shape2D]
var _polygons : Array[PackedVector2Array]

var _outer_radius := 100.0
var _inner_radius := 75.0

## When the target shape is an arch, what is the starting degree of that arch
@export var _arch_degrees := 45.0

func has_shapes() -> bool: return !_shapes.is_empty()
func has_polygons() -> bool: return !_polygons.is_empty()

func set_outer_radius(value: float) -> void: 
	_outer_radius = value
	_refresh_shapes_details()

func set_inner_radius(value: float) -> void: 
	_inner_radius = value
	_refresh_shapes_details()

func set_shape(shape: TargetShape) -> void:
	if _radar_shape == shape:
		return # no change
	_radar_shape = shape
	_setup_shape_arrays()

func draw(node: Node2D) -> void:
	# outline
	node.draw_circle(
		Vector2.ZERO, 
		_outer_radius,
		Utilties.COLOR_RADAR_PREVIEW, 
		false,
		5.0
	)

func _setup_shape_arrays() -> void:
	_polygons = []
	_shapes = []
	match _radar_shape:
		TargetShape.NA:
			return
		TargetShape.CIRCLE_FILLED:
			_shapes.append(CircleShape2D.new())
		TargetShape.ARCH_FILLED:
			_polygons.append([])
	_refresh_shapes_details()

func _refresh_shapes_details() -> void:
	if _radar_shape == TargetShape.NA:
		return
	if !(has_polygons() or has_shapes()):
		_setup_shape_arrays()
		return
	# assuming that _setup_shape_arrays has the correct stuff in the arrays
	match _radar_shape:
		RadarShapeInfo.TargetShape.CIRCLE_FILLED:
			_shapes[0].set_radius(_outer_radius)
		RadarShapeInfo.TargetShape.ARCH_FILLED:
			_polygons[0] = Utilties.get_arch_points(_outer_radius, deg_to_rad(_arch_degrees)*.5)
	changed.emit()
