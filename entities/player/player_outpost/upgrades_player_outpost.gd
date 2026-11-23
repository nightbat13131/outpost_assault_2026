class_name PlayerOutpostUpgrades extends Resource

enum UpgradeTypes {REPAIR_RATE = 3, UPGRADE_MAX = 4, KILL_BONUS = 5}

const RANK_EXPAND_RADAR : float = 0.1 # %
const RANK_EXPAND_COOLING : float = 0.05
const RANK_EXPAND_GEAR : float = 0.05

static var upgrade_prices: Dictionary = {
	UpgradeTypes.REPAIR_RATE: 300,
	UpgradeTypes.UPGRADE_MAX: 100,
	UpgradeTypes.KILL_BONUS: 100,
}

static var upgrade_levels_max : Dictionary[UpgradeTypes, int] = {
	UpgradeTypes.REPAIR_RATE: 3,
	UpgradeTypes.UPGRADE_MAX: 3,
	UpgradeTypes.KILL_BONUS: 3,
	}

static var upgrade_type_displaynames : Dictionary[UpgradeTypes, String] = {
	UpgradeTypes.REPAIR_RATE: "Outpost Repair",
	UpgradeTypes.UPGRADE_MAX: "Upgrade Max",
	UpgradeTypes.KILL_BONUS: "Kill Bonus",
	}

static var upgrade_type_tooltips : Dictionary[UpgradeTypes, String] = {
	UpgradeTypes.REPAIR_RATE: "Outpost Repair - Self repair rate.",
	UpgradeTypes.UPGRADE_MAX: "Upgrade Max - Increase max upgrade limit for towers.",
	UpgradeTypes.KILL_BONUS: "Kill Bonus - Increase reward for killing creeps.",
	}

var upgrade_levels : Dictionary[UpgradeTypes, int] = {
	UpgradeTypes.REPAIR_RATE : 0, 
	UpgradeTypes.UPGRADE_MAX : 0, 
	UpgradeTypes.KILL_BONUS : 0
	}

func attempt_upgrade_request(info: CostButtonInfo_OutpostUpgrades) -> void:
	var _upgrade_type := info.get_upgrade_type()
	if !is_type_maxed(_upgrade_type):
		## in case the _upgrade_type is missing from the dictionary
		upgrade_levels[_upgrade_type] = get_upgrade_level(_upgrade_type) +1
		changed.emit()

func is_type_maxed(upgrade_type: UpgradeTypes) -> bool:
	## TODO have the max upgrade level effected by outpost and global unlocks 
	return get_upgrade_level(upgrade_type) >= upgrade_levels_max[upgrade_type]

func get_upgrade_tooltip(upgrade_type: UpgradeTypes) -> String: # because I might made this less static in the future
	return upgrade_type_tooltips[upgrade_type]

func get_upgrade_cost(upgrade_type: UpgradeTypes) -> float: 
	if is_type_maxed(upgrade_type):
		return 0
	return upgrade_prices[upgrade_type] * (1 + get_upgrade_level(upgrade_type)*.1 )

func get_upgrade_level(upgrade_type: UpgradeTypes) -> int:
	return upgrade_levels.get(upgrade_type, 0)

func get_upgrade_ratio(upgrade_type: UpgradeTypes) -> float:
	return get_upgrade_level(upgrade_type) / float(upgrade_levels_max[upgrade_type])

#func get_foundation() -> Object: return _foundation
