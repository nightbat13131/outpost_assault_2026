class_name Shooter_Tower extends Shooter
## Shooter class with a couple checks to make sure values are valid for Tower

func set_reload_info(reload_info: ReloadInfo) -> void:
	if !reload_info is ReloadInfo_Tower:
		push_warning("Wrong Relaod info used in tower")
	super.set_reload_info(reload_info)

func get_upgrades() -> FoundationUpgrades: 
	var reload_info = get_reload_info()
	if reload_info is ReloadInfo_Tower:
		return reload_info.get_upgrades()
	return null

func get_tower_type() -> TowerInfo.TowerType:
	var reload_info = get_reload_info()
	if reload_info is ReloadInfo_Tower:
		return reload_info.get_tower_type()
	return TowerInfo.TowerType.NA

#region Effected by Upgrades

func get_rotation_speed_radian() -> float:
	var out := super.get_rotation_speed_radian()
	if get_upgrades() and false:
		var gear_level := get_upgrades().get_upgrade_level(FoundationUpgrades.UpgradeTypes.GEAR)
		out *= 1.0 + (gear_level * gear_level * FoundationUpgrades.RANK_EXPAND_GEAR)
	return out

func get_projectile_damage() -> float: 
	var out = super.get_projectile_damage()
	if get_upgrades():
		var cooling_level := get_upgrades().get_upgrade_level(FoundationUpgrades.UpgradeTypes.COOLING)
		match get_tower_type():
			TowerInfo.TowerType._OG_GATTLING:
				cooling_level = floor(cooling_level*.5)
			TowerInfo.TowerType._OG_MISSILE:
				cooling_level = max(cooling_level -3, 0)
		## so that each retained upgrade level is at least +1 damage
		var damage_up = max(out * cooling_level * FoundationUpgrades.RANK_EXPAND_COOLING, cooling_level)
		out += damage_up
	return out

func get_projectile_speed() -> float: 
	var out := super.get_projectile_speed()
	if get_upgrades():
		var gear_level := get_upgrades().get_upgrade_level(FoundationUpgrades.UpgradeTypes.GEAR)
		out *= 1.0 + (gear_level * gear_level * FoundationUpgrades.RANK_EXPAND_GEAR)
	return _projectile_base_speed

func get_projectile_spread_radian() -> float: 
	# TODO have projectile spread be effected by upgrades
	return deg_to_rad(randf_range(_projectile_base_spread_deg*-1, _projectile_base_spread_deg ) )
#endregion
