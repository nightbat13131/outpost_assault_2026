class_name Shooter extends Node2D

const EVENT_NO_TARGET = "no_target"
const EVENT_HAS_TARGET = "has_target"
const EVENT_DIE = "die"
const EVENT_JUST_SHOT = "just_shoot"
const EVENT_HAS_AMMO = "clip_ready"

@export var _projectile : PackedScene

@export_group("Rotation", "_rotation")
@export var _limit_roation := false
@export var _rotation_limit := TAU/8.0 : set = set_rotation_limit
@export var _rotation_speed_deg_sec := 45

@export var _clip_information : ReloadInfo
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
	_clip_information = _clip_information.duplicate()
	_clip_information.state_update.connect(send_event)

func set_foundation_upgrades(foundation_upgrades: FoundationUpgrades) -> void:
	_clip_information.setup(self, foundation_upgrades)

func set_targetting_mask(layer: int, flag := true) -> void:
	if _radar_sensor:
		_radar_sensor.set_collision_mask_value(layer, flag)
	if _aiming_sights:
		_aiming_sights.set_collision_mask_value(layer, flag)

func set_range(range_: float) -> void:
	_range = range_
	_aiming_sights.set_range(_range)
	_radar_sensor.set_range(_range)

func set_rotation_limit(radian: float) -> void: 
	_rotation_limit = radian
	_radar_sensor.set_arch_radius(radian)

func send_event(event: String) -> void:
	if _state_machine:
		_state_machine.send_event(event)
	else:
		push_warning("shooter no state machine")

func get_rotation_speed_radian() -> float:
	## todo: effected by upgrades
	return _rotation_speed_deg_sec * (TAU/360.0)

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
			_rotation_limit *-1,
			_rotation_limit
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
	var _projectile_speed = 100.0
	var _projectile_range = _range
	var _damage := 10.0
	projectile.setup(
		_muzzles.get_muzzle_location(), 
		global_rotation, 
		_projectile_speed, 
		_damage,
		_projectile_range,
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
