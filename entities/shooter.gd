class_name Shooter extends Node2D

const EVENT_NO_TARGET = "no_target"
const EVENT_HAS_TARGET = "has_target"
const EVENT_DIE = "die"
const EVENT_JUST_SHOT = "just_shoot"
const EVENT_HAS_AMMO = "clip_ready"

@export_group("Projectile", "_projectile")
@export var _projectile : PackedScene
@export var _projectile_base_speed := 500.0
@export var _projectile_base_damage := 3.0
@export var _projectile_base_spread_deg := .5

@export var _radar_shape: RadarShapeInfo

@export_group("Rotation", "_rotation")
@export var _limit_roation := false
@export var _rotation_limit_deg := 45.0 : set = set_rotation_limit
@export var _rotation_speed_deg_sec := 45

var _clip_information : ReloadInfo
@onready var _radar_sensor: RadarSensor = %RadarSensor

@onready var _aiming_sights: AimingSights = %AimingSights
@onready var _state_machine: StateChart = %ShooterStateChart
@onready var _muzzles: ShooterMuzzles = %Muzzles

## calculated and passed by parent because parents can be very different
var _range := 100.0

func _ready() -> void:
	_state_machine.propagate_call("set_shooter", [self])
	_state_machine.propagate_call("set_radar_sensor", [_radar_sensor])
	_radar_sensor.set_shooter(self)
	if _clip_information:
		_clip_information = _clip_information.duplicate()
		_clip_information.state_update.connect(send_event)

func set_clip_information(reload_info: ReloadInfo) -> void:
	_clip_information = reload_info
	_clip_information.state_update.connect(send_event)

func set_targetting_mask(layer: int, flag := true) -> void:
	if _radar_sensor:
		_radar_sensor.set_collision_mask_value(layer, flag)
	if _aiming_sights:
		_aiming_sights.set_collision_mask_value(layer, flag)

func set_range(range_: float) -> void:
	_range = range_
	_aiming_sights.set_range(_range)
	_radar_shape.set_outer_radius(range_)
	#_radar_sensor.set_range(_range)

func set_rotation_limit(degree: float) -> void: 
	_rotation_limit_deg = degree
	_radar_shape.set_arch_degrees(degree)
	#_radar_sensor.set_arch_radius(radian)

func send_event(event: String) -> void:
	if _state_machine:
		_state_machine.send_event(event)
	else:
		push_warning("shooter no state machine")

func get_rotation_speed_radian() -> float:
	## todo: effected by upgrades
	return deg_to_rad(_rotation_speed_deg_sec)

func get_radar_shape() -> RadarShapeInfo: return _radar_shape

func get_radar_sensor() -> RadarSensor: return _radar_sensor

func get_reload_info() -> ReloadInfo: return _clip_information

## Called by the State Machine
func state_process(modded_delta: float) -> void:
	if _clip_information:
		_clip_information.process(modded_delta)

## Called by the State Machine
func turn_towards(delta_moded: float, target_global_pos: Vector2) -> void:
	## TODO: consider rotational acceloration
	var target_global_angle = global_position.angle_to_point(target_global_pos)
	## lerp_angle slows down when getting close to target
	## otherwise this does point AT the correct location 
	#rotation = lerp_angle(rotation, target_angle, get_rotation_speed_radian() * delta_moded)
	var delta_radian : float = Utilties.delta_radian(global_rotation, target_global_angle)
	if is_equal_approx(delta_radian, 0.0):
		return # no rotation needed
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
		#if _clip_information.can_shoot():
		_shoot()

func _shoot() -> void:
	var projectile : Projectile = _projectile.instantiate()
	projectile.setup(
		_muzzles.get_muzzle_location(), 
		global_rotation + get_projectile_spread_radian(), 
		get_projectile_speed(), 
		get_projectile_damage(),
		get_projectile_range(),
		_radar_sensor.get_collision_mask(),
		null)
	_clip_information.shots_fired()
	if TowerHolder.get_instance():
		TowerHolder.get_instance().add_child(projectile)
	else:
		push_warning("no home for projetile to get added to")

func die() -> void:
	if _clip_information:
		_clip_information.die()
	_radar_sensor.die()
	send_event(EVENT_DIE)

func get_projectile_damage() -> float: 
	# TODO have projective damage be effected by upgrades
	return _projectile_base_damage

func get_projectile_speed() -> float: 
	# TODO have projective speed be effected by upgrades
	return _projectile_base_speed

func get_projectile_spread_radian() -> float: 
	# TODO have projective spread be effected by upgrades
	return deg_to_rad(randf_range(_projectile_base_spread_deg*-1, _projectile_base_spread_deg ) )

func get_projectile_range() -> float: 
	# TODO have projective range? be effected by upgrades
	return _range
