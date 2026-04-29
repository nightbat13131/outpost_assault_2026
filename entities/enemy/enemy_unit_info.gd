class_name EnemyUnitInfo extends EnemyUnitInfo_reference
## TODO: upgrade from spawn tower to make numbers go up
signal die

@export var _radar_shape: RadarShapeInfo: get = get_radar_shape
@export var _reload_info : ReloadInfo_Enemy: get = get_reload_info
@export var _projectile : ProjectileInfo
var _health_info: HealthInfo
#var _enemy : EnemyUnit

## Damage delt to Outpost if unit gets there
@export var _outpost_damage := 10.0
## Pixels per second
@export var speed: float = 150.0
## Degrees per second - how quickly... not currelty used. 
## Might try to use this value to control how fast items turn when taking a corner
@export var rotate_speed_body_deg : float = TAU
## Unit Starting health
@export var max_health := 100.0 : get = get_max_health
## Gold awarded upon death
@export var kill_reward := 100.0 : get = get_kill_reward

@export var _range := 150.0: get = get_range



func set_enemy(_unit: EnemyUnit) -> void:
	#_enemy = unit
	_health_info = HealthInfo.new()
	_health_info.die.connect(_on_die)
	_health_info.set_max_health(get_max_health(), true)
	if _radar_shape:
		_radar_shape.duplicate(true)
		_radar_shape.set_outer_radius(get_range())

func get_max_speed() -> float: return speed

func get_max_health() -> float: return max_health

func get_health_info() -> HealthInfo: return _health_info

func _on_die() -> void: 
	if get_reload_info():
		get_reload_info().die()
	die.emit()

func get_kill_reward() -> float: 
	if _health_info:
		if _health_info.get_health_ratio() <= 0:
		# if enemy is removed from the game without being killed, don't reward points?
			return kill_reward
		else:
			return 0.0
	return kill_reward

func take_damage(damage: float) -> bool: return _health_info.take_damage(damage)

func get_outpost_damange() -> float: return _outpost_damage

func get_body_rotate_limit_radian() -> float: return deg_to_rad(rotate_speed_body_deg)

func get_range() -> float: return _range

func get_radar_shape() -> RadarShapeInfo: return _radar_shape

func get_reload_info() -> ReloadInfo_Enemy: return _reload_info

func get_projectile_info() -> ProjectileInfo: return _projectile
