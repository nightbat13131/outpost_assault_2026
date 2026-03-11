class_name GlobalUnlocks extends RefCounted

enum UnlockStatus {UNKNOWN = -1, AVAILABLE = 0, LOCKED_VISIBLE = 1, HIDDEN = 2}


static func get_tower_unlock_statis(tower_type: TowerInfo.TowerType) -> UnlockStatus:
	return GlobalUnlocks.UnlockStatus.AVAILABLE
	
	#match tower_type:
		#TowerInfo.TowerType._NoShooter:
			#return UnlockStatus.LOCKED_VISIBLE
		#TowerInfo.TowerType._TEST_SHOOTER:
			#return UnlockStatus.AVAILABLE
		#TowerInfo.TowerType._TEST_TRUCK:
			#return UnlockStatus.HIDDEN
	#
	#return GlobalUnlocks.UnlockStatus.LOCKED_VISIBLE
