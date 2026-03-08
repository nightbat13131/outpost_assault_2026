class_name CostButtonInfo_Tower extends CostButtonInfo

@export var tower_type: TowerInfo.TowerType
var _foundation_upgrades: FoundationUpgrades
var _radar_preview : RadarPreview
var _unlock_status := GlobalUnlocks.UnlockStatus.UNKNOWN

func get_cost() -> float: 
	if _get_unlock_status() == GlobalUnlocks.UnlockStatus.AVAILABLE:
		return TowerInfo.get_tower_cost(tower_type)
	return -1

func get_label() -> String: return TowerInfo.get_tower_display_name(tower_type)

func get_tooltip() -> String: return super.get_tooltip()

func get_purchase_type() -> CostButton.PurchaseTypes: 
	if _get_unlock_status() == GlobalUnlocks.UnlockStatus.AVAILABLE:
		return CostButton.PurchaseTypes.ONE_SHOT
	return CostButton.PurchaseTypes.INFORMATION

func set_foundation(foundation: TowerFoundation) -> void:
	if foundation:
		_radar_preview = foundation.get_radar_preview()
		_foundation_upgrades = foundation.upgrades
	else: 
		push_warning("no foundation for CostButtonInfo_Tower")
		_radar_preview = null
		_foundation_upgrades = null

func on_mouse_entered() -> void:
	if _radar_preview:
		_radar_preview.set_preview(RadarSensor.TargetShape.CIRCLE_FILLED,
		{RadarPreview.OUTER_RADIUS: TowerInfo.get_tower_radar_outer_range(tower_type, _foundation_upgrades)}
		)

func on_mouse_exited() -> void:
	if _radar_preview:
		_radar_preview.cancle_preview()

func get_tower_type() -> TowerInfo.TowerType: return tower_type

func has_missing_dependency() -> bool: return _get_unlock_status() != GlobalUnlocks.UnlockStatus.AVAILABLE

func _get_unlock_status() -> GlobalUnlocks.UnlockStatus:
	if _unlock_status == GlobalUnlocks.UnlockStatus.UNKNOWN:
		_unlock_status = TowerInfo.get_tower_unlock_statis(get_tower_type())
	return _unlock_status
