class_name TowerInfo_reference extends Resource
## TODO: tower values will be effected by foundation and global upgrades

enum TowerType {NA = 0, 
	_NoShooter = 1, 
	_TEST_SHOOTER = -10, _TEST_TRUCK = -11,
	_OG_GATTLING = -21, _OG_CANNON = -22, _OG_MISSILE = -23
}

static var _type_to_outer_range :Dictionary[TowerType, float] = {
	TowerType._TEST_SHOOTER: 268.8, 
	TowerType._TEST_TRUCK: 400.0, 
	TowerType._OG_GATTLING: 360,
	TowerType._OG_CANNON: 315,
	TowerType._OG_MISSILE: 895,
}
static var _type_to_cost :Dictionary[TowerType, float] = {
	TowerType.NA: 5 ,
	TowerType._NoShooter: 25,
	TowerType._TEST_SHOOTER: 150,
	TowerType._TEST_TRUCK: 250, 
	TowerType._OG_GATTLING: 250,
	TowerType._OG_CANNON: 400,
	TowerType._OG_MISSILE: 800
}
static var _type_to_name :Dictionary[TowerType, String] = {
	TowerType._NoShooter: "Decoy",
	TowerType._TEST_SHOOTER: "Test Unit Shooter", 
	TowerType._TEST_TRUCK: "Test Ground Vehical Shooter",
	TowerType._OG_GATTLING: "Gattling",
	TowerType._OG_CANNON: "Cannon",
	TowerType._OG_MISSILE: "Missile"
}
## Here instead of on TowerInfo so that foundation can _ready spawn a tower based on a dropdown
static var _type_to_filepath : Dictionary[TowerType, String] = {
	TowerType._NoShooter: "uid://n0l8egj3gjg6",
	TowerType._TEST_SHOOTER: "uid://dofehy3c0bks6", 
	TowerType._TEST_TRUCK: "uid://o8lbby237l0n",
	TowerType._OG_GATTLING: 'uid://cdwrnm3uudkw4',
	TowerType._OG_CANNON: "uid://cxahwditwpjao",
	TowerType._OG_MISSILE: "uid://ddy7nmx6u5axg"
}
static var _type_to_max_hp :Dictionary[TowerType, float] = {
	TowerType._NoShooter: 400,
	TowerType._TEST_SHOOTER: 151.0, 
	TowerType._TEST_TRUCK: 150.0, 
	TowerType._OG_GATTLING: 151,
	TowerType._OG_CANNON: 226,
	TowerType._OG_MISSILE: 201
}

## Currently being entered as a value for the Projectile within TowerInfo 
#static var _type_to_damage :Dictionary[TowerType, float] = {
	#TowerType._TEST_SHOOTER: 5.0, 
	#TowerType._TEST_TRUCK: 150.0, 
	#TowerType._OG_GATTLING: 5,
	#TowerType._OG_CANNON: 25,
	#TowerType._OG_MISSILE: 25
#}

static func get_tower_display_name(tower_type_: TowerType) -> String: return _type_to_name.get(tower_type_, "No Name Set for " + str(int(tower_type_)))

static func get_tower_cost(tower_type_: TowerType) -> float: return _type_to_cost.get(tower_type_, 10)

static func get_tower_filepath(tower_type_: TowerType) -> String: return _type_to_filepath.get(tower_type_, "noFilepathSet")

static func get_tower_max_health(tower_type_: TowerType) -> float: return _type_to_max_hp.get(tower_type_, 5)

static func get_tower_radar_outer_range(tower_type_: TowerType, upgrades: FoundationUpgrades = null, delta_rank:=0) -> float: 
	## radar ranges calculated here instead of closer to radar to enable radar previewing 
	var base_range = _type_to_outer_range.get(tower_type_, 0.0)
	var range_mod := 1.0
	if upgrades:
		range_mod += (upgrades.get_upgrade_level(FoundationUpgrades.UpgradeTypes.RADAR) + delta_rank) * FoundationUpgrades.RANK_EXPAND_RADAR
	return base_range * range_mod

static func get_tower_unlock_statis(tower_type: TowerType) -> GlobalUnlocks.UnlockStatus:
	return GlobalUnlocks.get_tower_unlock_statis(tower_type)
