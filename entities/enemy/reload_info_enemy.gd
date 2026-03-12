class_name ReloadInfo_Enemy extends ReloadInfo

## Tower Type for calculations
var _tower_type: TowerInfo.TowerType : set = set_tower_type
## Upgrade reference for the shooter's foundation
var _foundation_upgrades : FoundationUpgrades

func set_tower_type(tower_type: TowerInfo.TowerType) -> void:
	_tower_type = tower_type

func set_foundation_upgrades(foundation_upgrads: FoundationUpgrades) -> void:
	if _foundation_upgrades: 
		_foundation_upgrades.changed.disconnect(_on_upgrade_changed)
	_foundation_upgrades = foundation_upgrads
	_foundation_upgrades.changed.connect(_on_upgrade_changed)
	_on_upgrade_changed()

func _on_upgrade_changed() -> void: changed.emit() # refresh drawing 
