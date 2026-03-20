class_name Shooter extends Node2D

const EVENT_NO_TARGET = "no_target"
const EVENT_HAS_TARGET = "has_target"
const EVENT_DIE = "die"
const EVENT_JUST_SHOT = "just_shoot"
const EVENT_HAS_AMMO = "clip_ready"

@export_group("Projectile", "_projectile")
var _projectile_info : ProjectileInfo : set = set_projectile_info, get = get_projectile_info
@export var _projectile : PackedScene
@export var _projectile_base_speed := 500.0
## TODO: move base damange to info
@export var _projectile_base_damage := 3.0
@export var _projectile_base_spread_deg := .5

@export_group("Rotation", "_rotation")
@export var _limit_roation := false
## Gets sent to Radar Shape
@export var _rotation_limit_deg := 45.0 : set = set_rotation_limit
@export var _rotation_speed_deg_sec := 45

var _reload_info : ReloadInfo : set = set_reload_info
var _radar_shape : RadarShapeInfo : set = set_radar_shape, get = get_radar_shape
@onready var _radar_sensor: RadarSensor = %RadarSensor
@onready var _aiming_sights: AimingSights = %AimingSights
@onready var _state_machine: StateChart = %ShooterStateChart
@onready var _muzzles: ShooterMuzzles = %Muzzles

## calculated and passed by parent because parents can be very different

func _ready() -> void:
	_state_machine.propagate_call("set_shooter", [self])
	_state_machine.propagate_call("set_radar_sensor", [_radar_sensor])
	_radar_sensor.set_shooter.call_deferred(self)

func set_projectile_info(info: ProjectileInfo) -> void: _projectile_info = info

func get_projectile_info() -> ProjectileInfo: return _projectile_info

func set_radar_shape(shape_info: RadarShapeInfo) -> void: 
	_radar_shape = shape_info
	_radar_sensor.set_radar_shape_info(shape_info)
	if _limit_roation:
		_radar_shape._arch_degrees = _rotation_limit_deg
	_aiming_sights.set_radar_shape(shape_info)

func set_reload_info(reload_info: ReloadInfo) -> void:
	_reload_info = reload_info
	_reload_info.state_update.connect(send_event)

func set_targetting_mask(layer: int, flag := true) -> void:
	if _radar_sensor:
		_radar_sensor.set_collision_mask_value(layer, flag)
	if _aiming_sights:
		_aiming_sights.set_collision_mask_value(layer, flag)

func set_rotation_limit(degree: float) -> void: _rotation_limit_deg = degree

func send_event(event: String) -> void:
	if _state_machine:
		_state_machine.send_event(event)
	else:
		push_warning("shooter no state machine")

#region Overwrite to apply Upgrads

func get_rotation_speed_radian() -> float: return deg_to_rad(_rotation_speed_deg_sec)

func get_projectile_damage() -> float: 
	if get_projectile_info():
		return get_projectile_info().get_damage()
	return _projectile_base_damage

func get_projectile_speed() -> float: 
	if get_projectile_info():
		return get_projectile_info().get_speed()
	return _projectile_base_speed

func get_projectile_spread_radian() -> float: 
	if get_projectile_info():
		return get_projectile_info().get_projectile_spread_radian()
	return deg_to_rad(randf_range(_projectile_base_spread_deg*-1, _projectile_base_spread_deg ) )

#endregion

func get_radar_shape() -> RadarShapeInfo: return _radar_shape

func get_radar_sensor() -> RadarSensor: return _radar_sensor

func get_reload_info() -> ReloadInfo: return _reload_info

## Called by the State Machine
func state_process(modded_delta: float) -> void:
	if _reload_info:
		_reload_info.process(modded_delta)

## Called by the State Machine
func turn_towards(delta_moded: float, target_global_pos: Vector2) -> void:
	## TODO: consider rotational acceloration
	var target_global_angle = global_position.angle_to_point(target_global_pos)
	## lerp_angle slows down when getting close to target
	## otherwise this does point AT the correct location 
	#rotation = lerp_angle(rotation, target_angle, get_rotation_speed_radian() * delta_moded)
	var delta_radian : float = Utilities.delta_radian(global_rotation, target_global_angle)
	if is_equal_approx(delta_radian, 0.0):
		return # no rotation needed
	print(get_rotation_speed_radian())
	var max_radian_swing = get_rotation_speed_radian() * delta_moded
	if delta_radian < 0.0:
		max_radian_swing *= -1
	max_radian_swing = clampf(max_radian_swing, abs(delta_radian) *-1, abs(delta_radian))
	var next_rotation = global_rotation + max_radian_swing
	#prints(global_rotation, rotation, global_rotation - rotation, get_parent().rotation)
	#global_rotation = next_rotation
	update_rotation(next_rotation - get_parent().rotation)

## Called by the State Machine
func look_forward(delta_moded: float) -> void:
	var parent = get_parent() as Node2D
	if parent:
		var point = parent.get_global_position()
		point += Vector2.from_angle(parent.global_rotation).normalized()
		turn_towards(delta_moded, point)

## use as a "set_rotation" so that limits on rotation can be maintained
func update_rotation(radian: float) -> void:
	if abs(radian) > PI:
		#prints(radian, fmod(radian, TAU), radian + TAU)
		## stops wierd studdering when the cirlce is being looped mathmaticly
		if radian < 0:
			radian += TAU
		else :
			radian -= TAU
	if _limit_roation:
		radian = clampf(
			radian, 
			 deg_to_rad( _rotation_limit_deg *-1),
			deg_to_rad(_rotation_limit_deg)
		)
	rotation = radian

## Called by the State Machine
func try_shoot() -> void:
	if _aiming_sights.is_colliding():
		## currently being handled by state machine
		#if get_reload_info().can_shoot():
		if _projectile_info:
			_shoot()
		else: 
			_shoot_no_info()

func _shoot() -> void:
	var projectile : Projectile # = _projectile.instantiate()
	var shot_count := 0
	for each_position in get_muzzle_locations():
		projectile = get_projectile_info().get_projectile()
		projectile.setup(
			each_position, 
			global_rotation + get_projectile_spread_radian(), 
			get_projectile_speed(), 
			get_projectile_damage(),
			get_projectile_range(),
			_radar_sensor.get_collision_mask(),
			null)
		if TowerHolder.get_instance():
			TowerHolder.get_instance().add_child(projectile)
			shot_count += 1
		else:
			push_warning("no home for projetile to get added to")
	get_reload_info().shots_fired(shot_count)

func _shoot_no_info() -> void:
	var projectile : Projectile = _projectile.instantiate()
	var shot_count := 0
	for each_position in get_muzzle_locations():
		projectile = _projectile.instantiate()
		projectile.setup(
			each_position, 
			global_rotation + get_projectile_spread_radian(), 
			get_projectile_speed(), 
			get_projectile_damage(),
			get_projectile_range(),
			_radar_sensor.get_collision_mask(),
			null)
		if TowerHolder.get_instance():
			TowerHolder.get_instance().add_child(projectile)
			shot_count += 1
		else:
			push_warning("no home for projetile to get added to")
	get_reload_info().shots_fired(shot_count)

func get_muzzle_locations() -> Array[Vector2]: return _muzzles.get_muzzle_location()

func die() -> void:
	if get_reload_info():
		get_reload_info().die()
	_radar_sensor.die()
	send_event(EVENT_DIE)

func get_projectile_range() -> float: return _radar_shape.get_outer_radius()

func set_parent_hovered(is_hover: bool ) -> void: _radar_sensor.set_parent_hovered(is_hover)

func set_parent_selected(is_selected: bool) -> void: _radar_sensor.set_parent_selected(is_selected)
