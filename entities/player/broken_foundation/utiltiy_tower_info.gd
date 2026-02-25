class_name TowerInfo extends RefCounted

enum TowerType {NA = 0, _NoShooter = 1, _TEST_UNIT = -10, _TEST_TRUCK = -11}

static var type_to_class :Dictionary = {
	TowerType.NA: Tower,
	TowerType._NoShooter: TowerNoGun,
	TowerType._TEST_UNIT: UnitTower, 
	TowerType._TEST_TRUCK: TruckTower
}
static var _type_to_radar_range :Dictionary[TowerType, float] = {
	TowerType._TEST_UNIT: 105.0, 
	TowerType._TEST_TRUCK: 145.0
}
static var _type_to_cost :Dictionary[TowerType, float] = {
	TowerType.NA: 5 ,
	TowerType._NoShooter: 25,
	TowerType._TEST_UNIT: 100,
	TowerType._TEST_TRUCK: 150
}

static var _type_to_name :Dictionary[TowerType, String] = {
	TowerType.NA: " Tower Type not set ",
	TowerType._NoShooter: "No Gun",
	TowerType._TEST_UNIT: "Unit", 
	TowerType._TEST_TRUCK: "Truck"
}

static var _type_to_max_hp :Dictionary[TowerType, float] = {
	TowerType.NA: 5.0,
	TowerType._NoShooter: 25,
	TowerType._TEST_UNIT: 100.0, 
	TowerType._TEST_TRUCK: 150.0
}

static func get_display_name(tower_type_: TowerType) -> String: return _type_to_name[tower_type_]

static func get_tower_cost(tower_type_: TowerType) -> float: return _type_to_cost.get(tower_type_, 10)

static func get_max_health(tower_type_: TowerType) -> float: return _type_to_max_hp.get(tower_type_, 5)

static func get_radar_range(tower_type_: TowerType, upgrades: FoundationUpgrades = null) -> float: 
	var base_range = _type_to_radar_range.get(tower_type_, 0.0)
	if upgrades == null:
		return base_range
	base_range *= (upgrades.get_upgrade_level(FoundationUpgrades.UpgradeTypes.RADAR) + 1)
	return base_range
