class_name RadarPreview extends Node2D

const OUTER_RADIUS = "outer_radius"

var _preview_on := false
var _radar_shape := RadarSensor.TargetShape.CIRCLE_FILLED
var _outer_radius := 150.0

func set_preview(shape: RadarSensor.TargetShape, args : Dictionary) -> void:
	queue_redraw()
	_preview_on = true
	_radar_shape = shape
	if args.has(OUTER_RADIUS):
		_outer_radius = args[OUTER_RADIUS]

func cancle_preview() -> void: 
	queue_redraw()
	_preview_on = false

func _draw() -> void:
	if !_preview_on:
		return
	match _radar_shape:
		RadarSensor.TargetShape.CIRCLE_FILLED:
			draw_filled_circle(self, _outer_radius)
		_: 
			draw_x(self, _outer_radius)

static func draw_filled_circle(node: Node2D, radius: float) -> void:
	node.draw_circle(
		Vector2.ZERO,
		radius,
		Utilties.COLOR_RADAR_PREVIEW, 
		false, 
		3
	)

static func draw_x(node: Node2D, radius: float) -> void:
	node.draw_line(
		Vector2(radius*-1, radius*-1), 
		Vector2(radius, radius), 
		Utilties.COLOR_RADAR_PREVIEW, 
		3
	)
	node.draw_line(
		Vector2(radius, radius*-1), 
		Vector2(radius*-1, radius), 
		Utilties.COLOR_RADAR_PREVIEW, 
		3
	)
