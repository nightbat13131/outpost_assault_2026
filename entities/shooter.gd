class_name Shooter extends Node2D

const EVENT_NO_TARGET = "no_target"
const EVENT_HAS_TARGET = "has_target"
const EVENT_DIE = "die"

@export var _projectile : PackedScene
@export var _rotation_speed_deg_sec := 45
@export var _clip_information : ReloadInfo
@onready var _radar_sensor: RadarSensor = %RadarSensor

@onready var _aiming_sights: AimingSights = %AimingSights
@onready var _state_machine: StateChart = %ShooterStateChart
@onready var _muzzles: ShooterMuzzles = %Muzzles

## calculated and passed by parent
var _range := 100.0
#var _foundation_upgrades : FoundationUpgrades

func _ready() -> void:
	_state_machine.propagate_call("set_shooter", [self])
	_state_machine.propagate_call("set_radar_sensor", [_radar_sensor])
	_radar_sensor.set_shooter(self)
	_clip_information = _clip_information.duplicate()


func set_foundation_upgrades(foundation_upgrades: FoundationUpgrades) -> void:
	_clip_information.setup(self, foundation_upgrades)

func _set_range(range_: float) -> void:
	_range = range_
	_aiming_sights.set_range(_range)
	_radar_sensor.set_radar_outer_range(_range)

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

func state_process(modded_delta: float) -> void:
	if _clip_information:
		_clip_information.process(modded_delta)

func turn_towards(delta_moded: float, target_global_pos: Vector2) -> void:
	## TODO: consider rotational acceloration
	var target_angle = global_position.angle_to_point(target_global_pos)
	## lerp_angle slows down when getting close to target
	## otherwise this does point AT the correct location 
	#rotation = lerp_angle(rotation, target_angle, get_rotation_speed_radian() * delta_moded)
	
	var delta_radian : float = Utilties.delta_radian(rotation, target_angle) # target_angle - rotation
	if is_equal_approx(delta_radian, 0.0):
		return # no rotation needed
	var max_radian_swing = get_rotation_speed_radian() * delta_moded
	#prints("A",max_radian_swing, target_angle)
	if delta_radian < 0.0:
		max_radian_swing *= -1
	max_radian_swing = clampf(max_radian_swing, abs(delta_radian) *-1, abs(delta_radian))
	#prints("C",max_radian_swing)
	rotation += max_radian_swing

## Called by the State Machine
func try_shoot() -> void:
	if _clip_information.can_shoot():
		## check relaod info
		#print("try shoot")
		#if _fired == 0:
		#	_fired += 1
		_shoot()

func _shoot() -> void:
	var projectile : Projectile = _projectile.instantiate()
	var _projectile_speed = 100.0
	var _projectile_range = _range
	var _damage := 10.0
	projectile.setup(
		_muzzles.get_muzzle_location(), 
		rotation, 
		_projectile_speed, 
		_damage, 
		null, 
		_projectile_range)
	_clip_information.shots_fired()
	if TowerHolder.get_instance():
		TowerHolder.get_instance().add_child(projectile)
	else:
		push_warning("no home for projetile to get added to")

func die() -> void:
	if _clip_information:
		_clip_information.die()
	send_event(EVENT_DIE)
