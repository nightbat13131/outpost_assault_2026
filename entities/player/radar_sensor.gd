class_name RadarSensor extends Area2D

enum TargetingMethod {NA = 0, RADIAN_CLOSE = 1}
enum TargetShape {NA = 0, CIRCLE_FILLED = 1}

const COLLISION_ENEMY_HUMANS = 3

const COLLISION_ANY_BUILDING = 9
const COLLISION_ENEMY_BUILDING = 10
const COLLISION_PLAYER_BUILDING = 11

const RADAR_FADE := .25

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

@export var _debugging_targets := false
var _radar_preview: float = 2.0
var _targets : Array =[]
@export var _targeting_method := TargetingMethod.NA
var _upgrades : FoundationUpgrades
var _shooter : Shooter

func _ready() -> void:
	collision_shape_2d.set_shape(CircleShape2D.new())
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func has_target() -> bool: return !_targets.is_empty()

func set_shooter(shooter: Shooter) -> void: _shooter = shooter

func on_tower_died() -> void: set_radar_outer_range(0.0)

func set_radar_outer_range(range_: float) -> void: 
	collision_shape_2d.get_shape().set_radius(range_)
	queue_redraw()

func set_target_collition_types(target_collition_mask: int) -> void:
	set_collision_mask(target_collition_mask)
	#TODO: recalculate targets in current area

func set_target_method(target_method: TargetingMethod) -> void:
	_targeting_method = target_method
	#TODO: recalculate targets in current area

func set_target_logic() -> void:
	pass

func get_target() -> Node2D:
	if _targets.is_empty():
		return null
	match _targeting_method:
		TargetingMethod.RADIAN_CLOSE:
			return _get_target_radian_close()
	return _targets[0]

func preview_radar_range_tower(tower_type:= TowerInfo.TowerType.NA) -> void: 
	if TowerInfo.TowerType.NA:
		_radar_preview = 0.0
	else:
		_radar_preview = TowerInfo.get_radar_range(tower_type, _upgrades)
	queue_redraw()

func _draw() -> void:
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
	print(_targets)

func _on_area_exited(area: Area2D) -> void:
	while _targets.has(area):
		_targets.erase(area)
		queue_redraw()
	print(_targets)

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
