@tool
class_name RadarSensor extends Area3D

const DEBUGING = true
const DEBUG_SHIFT = 1.0

enum TargetingMethod {NA = 0, RADIAN_CLOSE = 1}

## helpful for debuggin mask values https://www.bitmask.foo/
## Collision layer number must be between 1 and 32 inclusive, instead of starting at 0.

const COLLISION_GROUND = 1
const COLLISION_ENEMY_HUMANS = 3
const COLLISION_ANY_BUILDING = 9
const COLLISION_ENEMY_BUILDING = 10
const COLLISION_PLAYER_BUILDING = 11

const RADAR_FADE := .25

@export var _debugging_targets := false

@export var _targeting_method := TargetingMethod.NA

@onready var collision_shape: CollisionShape3D = %CollisionShape
@onready var collision_polygon: CollisionPolygon3D = %CollisionPolygon

var _shooter : Shooter
var _player_outpost : PlayerOutpost
var _radar_shape : RadarShapeInfo: set = set_radar_shape_info, get = get_radar_shape
var _targets : Array =[]
var _parent_selected := false 
var _parent_hovered := false 

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_radar_shape_change() -> void: 
	collision_shape.set_disabled(!_radar_shape.has_shapes())
	if _radar_shape.has_shapes():
		collision_shape.set_shape(_radar_shape.get_shapes()[0])
	else: 
		collision_shape.set_shape(null)
	collision_polygon.set_disabled(!_radar_shape.has_polygons())
	if _radar_shape.has_polygons():
		collision_polygon.set_polygon(_radar_shape.get_polygons()[0])
	else:
		collision_polygon.set_polygon([])

func get_radar_shape() -> RadarShapeInfo: return _radar_shape

func set_radar_shape_info(shape_info: RadarShapeInfo) -> void: 
	_radar_shape = shape_info
	if _radar_shape:
		#_radar_shape.changed.connect(queue_redraw)
		_radar_shape.shape_changed.connect(_on_radar_shape_change)
		_radar_shape.poly_changed.connect(_on_radar_shape_change)
	_on_radar_shape_change()
	#queue_redraw()

func set_shooter(shooter: Shooter) -> void: 
	_shooter = shooter

func die() -> void: 
	if Engine.is_editor_hint():
		return
	for each_child in get_children():
		if each_child.has_method("set_disabled"):
			each_child.set_disabled(true)
	#queue_free()

## For when the Radar's rotation needs to match a different node.
func set_rotation_parent(node: Node3D) -> void: Utilities.reparent(self, node)

func set_parent_hovered(is_hover: bool ) -> void:
	_parent_hovered = is_hover
	#queue_redraw()

func set_parent_selected(is_selected: bool) -> void:
	_parent_selected = is_selected
	#queue_redraw()

#func _draw() -> void:
	#if get_radar_shape():
		#if _parent_hovered or _parent_selected or _debugging_targets:
			#get_radar_shape().draw(self)
	#if !_debugging_targets:
		#return
	#if has_target():
		#var center: Vector2
		#var color : Color
		#var count = _targets.size()
		#for index in range(count):
			#center = to_local(_targets[index].get_global_position())
			#color = Color.from_hsv(index/float(count), 1,1,1)
			#draw_circle(
			#center, 
			#30.0, 
			#color,
			#false, 2.0
			#)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or DEBUGING:
		var radius := 1.0
		if _radar_shape:
			radius = _radar_shape.get_outer_radius()
		var s_xf: Transform3D = global_transform
		#DebugDraw3D.draw_sphere(s_xf.origin, target_distance, Color.BLUE_VIOLET)
		#DebugDraw3D.draw_cylinder(s_xf, Color.BLUE_VIOLET, 0.0)
		#DebugDraw3D.draw_cylinder_ab(
			#Vector3(s_xf.origin)
			#,Vector3(s_xf.origin.x, s_xf.origin.y + DEBUG_SHIFT, s_xf.origin.z)
			#, radius
			#, Color.BLUE_VIOLET
		#)
	if !_debugging_targets:
		return
	DebugDraw3D.draw_sphere(
		get_global_position(), 
		1.0, 
		Color(Color.NAVAJO_WHITE, .5),
		#false, 2.0
		)
	
	if has_target():
		print_debug(_targets)
		var center: Vector3 = get_global_position()
		var color : Color
		var count = _targets.size()
		
		for index in range(count):
			center = _targets[index].get_global_position()
			color = Color.from_hsv(index/float(count), 1,1,1)
			DebugDraw3D.draw_sphere(
			center, 
			4.0, 
			color,
			#false, 2.0
			)

func has_target() -> bool: return !_targets.is_empty()

func set_targetting_mask(layer: int, flag := true) -> void: set_collision_mask_value(layer, flag)

func set_target_method(target_method: TargetingMethod) -> void:
	_targeting_method = target_method

func set_target_logic() -> void: pass

func get_target() -> Node3D:
	if _targets.is_empty():
		return null
	if _targets.has(_player_outpost):
		return _player_outpost
	match _targeting_method:
		TargetingMethod.RADIAN_CLOSE:
			return _get_target_radian_close()
	return _targets[0]

func _get_target_radian_close() -> Node3D:
	var starting_radian := _shooter.global_rotation.y
	var min_delta_rotation := TAU
	var min_target : Node3D = null
	
	var each_rotation := TAU
	var each_delta_radian := TAU
	
	var global_2d = Utilities.shift_3d_to_2d(global_position)
	
	for each in _targets: # TODO: this likely is broken
		each_rotation = global_2d.angle_to_point(Utilities.shift_3d_to_2d(each.get_global_position()))
		each_delta_radian = Utilities.delta_radian(starting_radian, each_rotation)
		if abs(each_delta_radian) < min_delta_rotation:
			min_delta_rotation = abs(each_delta_radian)
			min_target = each
	return min_target

func _on_area_entered(area: Area2D) -> void:
	if !_targets.has(area):
		_targets.append(area)
		#queue_redraw()
	#print(_targets)

func _on_area_exited(area: Area3D) -> void:
	while _targets.has(area):
		_targets.erase(area)
		#queue_redraw()
	#print(_targets)

func _on_body_entered(body: Node3D) -> void:
	if !_targets.has(body):
		_targets.append(body)
		#queue_redraw()
	#print(_targets)

func _on_body_exited(body: Node3D) -> void:
	while _targets.has(body):
		_targets.erase(body)
		#queue_redraw()
