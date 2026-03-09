class_name RadarSensor extends Area2D

enum TargetingMethod {NA = 0, RADIAN_CLOSE = 1}

## helpful for debuggin mask values https://www.bitmask.foo/
## Collision layer number must be between 1 and 32 inclusive, instead of starting at 0.

const COLLISION_ENEMY_HUMANS = 3
const COLLISION_ANY_BUILDING = 9
const COLLISION_ENEMY_BUILDING = 10
const COLLISION_PLAYER_BUILDING = 11

const RADAR_FADE := .25

@export var _debugging_targets := false

@export var _targeting_method := TargetingMethod.NA
@export var _radar_shape := RadarShapeInfo.TargetShape.CIRCLE_FILLED

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var collision_polygon_2d: CollisionPolygon2D = %CollisionPolygon2D

var _shooter : Shooter
var _player_outpost : PlayerOutpost
var _targets : Array =[]
var _outer_range := 100.0
var _arch_radius := 1.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	#_setup_collision()

func _setup_collision_old() -> void:
	match _radar_shape:
		RadarShapeInfo.TargetShape.CIRCLE_FILLED:
			collision_shape_2d.set_shape(CircleShape2D.new())
			collision_polygon_2d.set_disabled(true)
			collision_polygon_2d.set_polygon([])
		RadarShapeInfo.TargetShape.ARCH_FILLED:
			collision_shape_2d.set_shape(CircleShape2D.new())
			collision_shape_2d.set_disabled(true)
			collision_polygon_2d.set_polygon([])
	#_refresh_collision_shapes()
'
func _refresh_collision_shapes() -> void:
	match _radar_shape:
		RadarShapeInfo.TargetShape.CIRCLE_FILLED:
			collision_shape_2d.get_shape().set_radius(_outer_range)
		RadarShapeInfo.TargetShape.ARCH_FILLED:
			collision_polygon_2d.set_polygon(Utilties.get_arch_points(_outer_range, _arch_radius))
'
func has_target() -> bool: return !_targets.is_empty()

func get_radar_shape() -> RadarShapeInfo: return _shooter.get_radar_shape()

func set_shooter(shooter: Shooter) -> void: 
	_shooter = shooter
	_shooter.get_radar_shape().changed.connect(queue_redraw)

func die() -> void: 
	for each_child in get_children():
		if each_child.has_method("set_disabled"):
			each_child.set_disabled(true)
	queue_free()

#func set_range(range_: float) -> void:
	#_outer_range = range_
	#_refresh_collision_shapes()

#func set_arch_radius(radian: float) -> void:
	#_arch_radius = radian
	#_refresh_collision_shapes()

func set_target_collition_types(target_collition_mask: int) -> void:
	set_collision_mask(target_collition_mask)
	#TODO: recalculate targets in current area

func set_target_method(target_method: TargetingMethod) -> void:
	_targeting_method = target_method

func set_target_logic() -> void: pass

func get_target() -> Node2D:
	if _targets.is_empty():
		return null
	if _targets.has(_player_outpost):
		return _player_outpost
	match _targeting_method:
		TargetingMethod.RADIAN_CLOSE:
			return _get_target_radian_close()
	return _targets[0]

## For when the Radar's rotation needs to match a different node.
func set_rotation_parent(node: Node2D) -> void: 
	#_rotation_parent = node
	Utilties.reparent(self, node)

func _draw() -> void:
	get_radar_shape().draw(self)
	if !_debugging_targets:
		return
	if has_target():
		var center: Vector2
		var color : Color
		var count = _targets.size()
		for index in range(count):
			center = to_local(_targets[index].get_global_position())
			color = Color.from_hsv(index/float(count), 1,1,1)
			draw_circle(
			center, 
			30.0, 
			color,
			false, 2.0
			)

func _process(_delta: float) -> void:
	if !_debugging_targets:
		return
	if has_target():
		queue_redraw()

func _on_area_entered(area: Area2D) -> void:
	if !_targets.has(area):
		_targets.append(area)
		queue_redraw()
	#print(_targets)

func _on_area_exited(area: Area2D) -> void:
	while _targets.has(area):
		_targets.erase(area)
		queue_redraw()
	#print(_targets)

func _on_body_entered(body: Node2D) -> void:
	if !_targets.has(body):
		_targets.append(body)
		queue_redraw()
	#print(_targets)

func _on_body_exited(body: Node2D) -> void:
	while _targets.has(body):
		_targets.erase(body)
		queue_redraw()

func _get_target_radian_close() -> Node2D:
	var starting_radian = _shooter.global_rotation
	var min_delta_rotation := TAU
	var min_target : Node2D = null
	
	var each_rotation := TAU
	var each_delta_radian := TAU
	
	for each in _targets:
		each_rotation = global_position.angle_to_point(each.get_global_position())
		each_delta_radian = Utilties.delta_radian(starting_radian, each_rotation)
		if abs(each_delta_radian) < min_delta_rotation:
			min_delta_rotation = abs(each_delta_radian)
			min_target = each
	return min_target
