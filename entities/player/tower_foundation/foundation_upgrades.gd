class_name FoundationUpgrades extends Resource

enum UpgradeTypes {RADAR = 0, GEAR = 1, COOLING = 2}

var _foundation : TowerFoundation

static var upgrade_levels_max : Dictionary[UpgradeTypes, int] = {
	UpgradeTypes.RADAR : 5, 
	UpgradeTypes.GEAR : 4, 
	UpgradeTypes.COOLING : 2
	}

static var upgrade_type_displaynames : Dictionary[UpgradeTypes, String] = {
	UpgradeTypes.RADAR : "Radar", 
	UpgradeTypes.GEAR : "Gearbox", 
	UpgradeTypes.COOLING : "Cooling" 
	}

static var upgrade_type_tooltips : Dictionary[UpgradeTypes, String] = {
	UpgradeTypes.RADAR : "Radar - Range and targeting abilities", 
	UpgradeTypes.GEAR : "Gearbox - better rotational things", 
	UpgradeTypes.COOLING : "Cooling - stuff heat would damange" 
	}

@export var upgrade_levels : Dictionary[UpgradeTypes, int] = {
	UpgradeTypes.RADAR : 0, 
	UpgradeTypes.GEAR : 0, 
	UpgradeTypes.COOLING : 0
	}

func set_foundation(foundation: TowerFoundation) -> void:
	_foundation = foundation

func attempt_upgrade_request(info: CostButonInfo_FoundationUpgrads) -> void:
	var _upgrade_type := info.get_upgrade_type()
	if !is_type_maxed(_upgrade_type):
		upgrade_levels[_upgrade_type] += 1
		changed.emit()

func is_type_maxed(upgrade_type: UpgradeTypes) -> bool:
	return upgrade_levels[upgrade_type] >= upgrade_levels_max[upgrade_type]

func get_upgrade_tooltip(upgrade_type: UpgradeTypes) -> String: # because I might made this less static in the future
	return upgrade_type_tooltips[upgrade_type]

func get_upgrade_cost(upgrade_type: UpgradeTypes) -> float: 
	if is_type_maxed(upgrade_type):
		return 0
	return 100 + 20.0 * randi_range(1,5)

func get_upgrade_level(upgrade_type: UpgradeTypes) -> int:
	return upgrade_levels[upgrade_type]

func get_upgrade_ratio(upgrade_type: UpgradeTypes) -> float:
	return upgrade_levels[upgrade_type] / float(upgrade_levels_max[upgrade_type])

func get_foundation() -> TowerFoundation: return _foundation
