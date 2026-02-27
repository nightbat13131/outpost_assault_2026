class_name TowerInfo extends Resource
## TODO: tower values will be effected by foundation and global upgrades

enum TowerType {NA = 0, _NoShooter = 1, _TEST_SHOOTER = -10, _TEST_TRUCK = -11}

@export var my_type: TowerType
var _health_info: HealthInfo # because health effects some calculations
var _upgrades : FoundationUpgrades

func set_health_info(info: HealthInfo) -> void: _health_info = info
func set_upgrade_info(info: FoundationUpgrades) -> void: _upgrades = info

func get_max_health() -> float: return get_tower_max_health(my_type)
func get_cost() -> float: return get_tower_cost(my_type)
func get_display_name() -> String: return get_tower_display_name(my_type)
func get_outer_range() -> float: return get_tower_radar_outer_range(my_type, _upgrades)

func get_sell_value() -> float: return get_cost() * _health_info.get_health_ratio()
func get_repair_value() -> float: return get_cost() * (1.0- _health_info.get_health_ratio())


#static var type_to_class :Dictionary = {
	#TowerType.NA: Tower,
	#TowerType._NoShooter: TowerNoGun,
	#TowerType._TEST_SHOOTER: TowerShooter, 
	#TowerType._TEST_TRUCK: TruckTower
#}
static var _type_to_outer_range :Dictionary[TowerType, float] = {
	TowerType._TEST_SHOOTER: 105.0, 
	TowerType._TEST_TRUCK: 145.0
}
static var _type_to_cost :Dictionary[TowerType, float] = {
	TowerType.NA: 5 ,
	TowerType._NoShooter: 25,
	TowerType._TEST_SHOOTER: 100,
	TowerType._TEST_TRUCK: 150
}
static var _type_to_name :Dictionary[TowerType, String] = {
	TowerType._NoShooter: "Decoy",
	TowerType._TEST_SHOOTER: "Tower Shooter", 
	TowerType._TEST_TRUCK: "Truck"
}
static var _type_to_filepath : Dictionary[TowerType, String] = {
	TowerType._NoShooter: "uid://n0l8egj3gjg6",
	TowerType._TEST_SHOOTER: "uid://dro1735nlrdor", 
	TowerType._TEST_TRUCK: "uid://o8lbby237l0n"
}
static var _type_to_max_hp :Dictionary[TowerType, float] = {
	TowerType._NoShooter: 400,
	TowerType._TEST_SHOOTER: 100.0, 
	TowerType._TEST_TRUCK: 150.0
}

static func get_tower_display_name(tower_type_: TowerType) -> String: return _type_to_name.get(tower_type_, "No Name Set for " + str(int(tower_type_)))

static func get_tower_cost(tower_type_: TowerType) -> float: return _type_to_cost.get(tower_type_, 10)

static func get_tower_filepath(tower_type_: TowerType) -> String: return _type_to_filepath.get(tower_type_, "noFilepathSet")

static func get_tower_max_health(tower_type_: TowerType) -> float: return _type_to_max_hp.get(tower_type_, 5)

static func get_tower_radar_outer_range(tower_type_: TowerType, upgrades: FoundationUpgrades = null) -> float: 
	var base_range = _type_to_outer_range.get(tower_type_, 0.0)
	if upgrades == null:
		return base_range
	base_range *= (upgrades.get_upgrade_level(FoundationUpgrades.UpgradeTypes.RADAR) + 1)
	return base_range
