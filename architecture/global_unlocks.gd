class_name GlobalUnlocks extends RefCounted

enum UnlockStatus {UNKNOWN = -1, AVAILABLE = 0, LOCKED_VISIBLE = 1, HIDDEN = 2}

static func get_tower_unlock_status(_tower_type: TowerInfo.TowerType) -> UnlockStatus:
	if Level.is_tower_allowed(_tower_type):
		return GlobalUnlocks.UnlockStatus.AVAILABLE
	return GlobalUnlocks.UnlockStatus.HIDDEN

static func get_player_outpost_upgrade_unlock_status(_tower_type: PlayerOutpostUpgrades.UpgradeTypes) -> UnlockStatus:
	if Level.is_outpost_upgrade_allowed(_tower_type):
		return GlobalUnlocks.UnlockStatus.AVAILABLE
	return GlobalUnlocks.UnlockStatus.HIDDEN
