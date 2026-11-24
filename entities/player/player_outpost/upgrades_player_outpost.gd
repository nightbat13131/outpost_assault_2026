class_name PlayerOutpostUpgrades extends Resource

enum UpgradeTypes {REPAIR_RATE = 3, UPGRADE_MAX = 4, KILL_BONUS = 5}

static var _upgrade_prices: Dictionary = {
	UpgradeTypes.REPAIR_RATE: 300,
	UpgradeTypes.UPGRADE_MAX: 100,
	UpgradeTypes.KILL_BONUS: 100,
	}

static var _upgrade_levels_max : Dictionary[UpgradeTypes, int] = {
	UpgradeTypes.REPAIR_RATE: 3,
	UpgradeTypes.UPGRADE_MAX: 3,
	UpgradeTypes.KILL_BONUS: 3,
	}

static var _upgrade_type_displaynames : Dictionary[UpgradeTypes, String] = {
	UpgradeTypes.REPAIR_RATE: "Outpost Repair",
	UpgradeTypes.UPGRADE_MAX: "Upgrade Max",
	UpgradeTypes.KILL_BONUS: "Kill Bonus",
	}

static var _upgrade_type_tooltips : Dictionary[UpgradeTypes, String] = {
	UpgradeTypes.REPAIR_RATE: "Outpost Repair - Self repair rate.",
	UpgradeTypes.UPGRADE_MAX: "Upgrade Max - Increase max upgrade limit for towers.",
	UpgradeTypes.KILL_BONUS: "Kill Bonus - Increase reward for killing creeps.",
	}

var _upgrade_levels : Dictionary[UpgradeTypes, int] = {
	UpgradeTypes.REPAIR_RATE : 0, 
	UpgradeTypes.UPGRADE_MAX : 0, 
	UpgradeTypes.KILL_BONUS : 0
	}

func attempt_upgrade_request(info: CostButtonInfo_OutpostUpgrades) -> void:
	var _upgrade_type := info.get_upgrade_type()
	if !is_type_maxed(_upgrade_type):
		## in case the _upgrade_type is missing from the dictionary
		_upgrade_levels[_upgrade_type] = get_upgrade_level(_upgrade_type) +1
		changed.emit()

func is_type_maxed(upgrade_type: UpgradeTypes) -> bool:
	return get_upgrade_level(upgrade_type) >= _get_max_upgrade_level(upgrade_type)

func get_upgrade_name(upgrade_type: UpgradeTypes) -> String: 
	return _upgrade_type_displaynames.get(upgrade_type, "")

func get_upgrade_tooltip(upgrade_type: UpgradeTypes) -> String: # because I might made this less static in the future
	var ranking := "\n" + str(get_upgrade_level(upgrade_type)) + "/" + str(_get_max_upgrade_level(upgrade_type))
	if upgrade_type == UpgradeTypes.KILL_BONUS:
		ranking += " " + str( "%0.0f%%" % (get_banking_bonus()*100 ) ) 
		if !is_type_maxed(upgrade_type):
			ranking += " -> " + str( "%0.0f%%" % (get_banking_bonus(true)*100 ) )
	return _upgrade_type_tooltips.get(upgrade_type, "") + ranking

func get_upgrade_cost(upgrade_type: UpgradeTypes) -> float: 
	if is_type_maxed(upgrade_type):
		return 0
	return _upgrade_prices[upgrade_type] * (1 + get_upgrade_level(upgrade_type) )

func get_upgrade_level(upgrade_type: UpgradeTypes) -> int:
	return _upgrade_levels.get(upgrade_type, 0)

func _get_max_upgrade_level(upgrade_type: UpgradeTypes) -> int:
	return _upgrade_levels_max.get(upgrade_type, 0) 

func get_upgrade_ratio(upgrade_type: UpgradeTypes) -> float:
	return get_upgrade_level(upgrade_type) / float(_get_max_upgrade_level(upgrade_type))

func get_max_upgrade_mod() -> int: return get_upgrade_level(UpgradeTypes.UPGRADE_MAX)

func get_banking_bonus(upgraded := false) -> float: 
	var rank := get_upgrade_level(UpgradeTypes.KILL_BONUS)
	if upgraded and !is_type_maxed(UpgradeTypes.KILL_BONUS):
		rank +=1
	return rank * rank * 0.1

func get_hp_repair_per_second() -> float: return get_upgrade_level(UpgradeTypes.REPAIR_RATE)
