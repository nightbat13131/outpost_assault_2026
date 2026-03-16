class_name ReloadInfo_Tower extends ReloadInfo

## Tower Type for calculations
var _tower_type: TowerInfo.TowerType : set = set_tower_type, get = get_tower_type
## Upgrade reference for the shooter's foundation
var _foundation_upgrades : FoundationUpgrades: set = set_foundation_upgrades, get = get_upgrades

func set_tower_type(tower_type: TowerInfo.TowerType) -> void:
	_tower_type = tower_type

func get_tower_type() -> TowerInfo.TowerType: return _tower_type

func set_foundation_upgrades(foundation_upgrads: FoundationUpgrades) -> void:
	if _foundation_upgrades: 
		_foundation_upgrades.changed.disconnect(_on_upgrade_changed)
	_foundation_upgrades = foundation_upgrads
	_foundation_upgrades.changed.connect(_on_upgrade_changed)
	_on_upgrade_changed()

func get_upgrades() -> FoundationUpgrades: return _foundation_upgrades

func _on_upgrade_changed() -> void: changed.emit() # refresh drawing 

#region Effected by Upgrades

func get_clip_ammo_size() -> int: 
	var out := super.get_clip_ammo_size()
	if get_upgrades():
		var cooling_level := get_upgrades().get_upgrade_level(FoundationUpgrades.UpgradeTypes.COOLING)
		match get_tower_type(): 
			TowerInfo.TowerType._OG_GATTLING:
				out += cooling_level
			TowerInfo.TowerType._OG_CANNON:
				pass
			TowerInfo.TowerType._OG_MISSILE:
				out =+ cooling_level
				out = clamp(out, 1, 4) 
	return out

func get_burst_delay_seconds() -> float: 
	var out := super.get_burst_delay_seconds()
	if get_upgrades():
		var gear_level := get_upgrades().get_upgrade_level(FoundationUpgrades.UpgradeTypes.GEAR)
		var gear_percent := (1.0 - ( gear_level * gear_level * FoundationUpgrades.RANK_EXPAND_GEAR))
		if get_clip_ammo_size() > 1: 
			out *= gear_percent
	return max(out, SMALLEST_SPEED) ## Protect against too small speeds

func get_clip_reload_seconds() -> float:
	var out := super.get_clip_reload_seconds()
	if get_upgrades():
		var cool_level := get_upgrades().get_upgrade_level(FoundationUpgrades.UpgradeTypes.COOLING)
		var cool_percent := (1.0 - ( cool_level * cool_level * FoundationUpgrades.RANK_EXPAND_COOLING))
		if get_clip_ammo_size() > 1: 
			out *= cool_percent
	return max(out, SMALLEST_SPEED) ## Protect against too small speeds

#endregion
