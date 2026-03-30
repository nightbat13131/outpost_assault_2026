class_name TowerInfo extends TowerInfo_reference
## TODO: tower values will be effected by foundation and global upgrades

@export var my_type: TowerType
@export var _radar_shape: RadarShapeInfo: get = get_radar_shape
@export var _reload_info : ReloadInfo_Tower: get = get_reload_info
@export var _projectile : ProjectileInfo

var _health_info: HealthInfo # because health effects some calculations
var _upgrades : FoundationUpgrades : set = set_upgrade_info

func post_duplication() -> void:
	if get_reload_info():
		_reload_info = get_reload_info().duplicate(true)
		get_reload_info().set_tower_type(my_type)

func get_health_info() -> HealthInfo: 
	if _health_info == null:
		_health_info = HealthInfo.new()
		_health_info.set_max_health(get_max_health(), true)
	return _health_info

func set_upgrade_info(info: FoundationUpgrades) -> void: 
	_on_upgrade_changed()
	if _upgrades == info: # no change needed
		return
	_upgrades = info
	_upgrades.changed.connect(_on_upgrade_changed)
	if _reload_info:
		_reload_info.set_foundation_upgrades(info)

func _on_upgrade_changed() -> void:
	if _radar_shape:
		_radar_shape.set_outer_radius(get_outer_range())

func get_radar_shape() -> RadarShapeInfo: return _radar_shape

func get_reload_info() -> ReloadInfo_Tower: return _reload_info

func get_max_health() -> float: return get_tower_max_health(my_type)

func get_cost() -> float: return get_tower_cost(my_type)

func get_display_name() -> String: return get_tower_display_name(my_type)

func get_outer_range() -> float: return get_tower_radar_outer_range(my_type, _upgrades)

func get_sell_value() -> float: return get_cost() * _health_info.get_health_ratio()

func get_repair_value() -> float: return get_cost() * (1.0- _health_info.get_health_ratio())

func get_upgraded_range() -> float: return get_tower_radar_outer_range(my_type, _upgrades, 1)

func get_projectile_info() -> ProjectileInfo: return _projectile
