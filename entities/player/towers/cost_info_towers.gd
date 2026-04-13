class_name CostButtonInfo_Tower extends CostButtonInfo

@export var tower_info : TowerInfo
var _radar_preview : RadarPreview
var _unlock_status := GlobalUnlocks.UnlockStatus.UNKNOWN

func get_cost() -> float: 
	if _get_unlock_status() == GlobalUnlocks.UnlockStatus.AVAILABLE:
		return tower_info.get_cost()
	return -1

func get_label() -> String: return tower_info.get_display_name()

func get_tooltip() -> String: return super.get_tooltip()

func get_purchase_type() -> CostButton.PurchaseTypes: 
	if _get_unlock_status() == GlobalUnlocks.UnlockStatus.AVAILABLE:
		return CostButton.PurchaseTypes.ONE_SHOT
	return CostButton.PurchaseTypes.INFORMATION

func set_foundation(foundation: Object) -> void:
	if foundation is TowerFoundation2D:
		_radar_preview = foundation.get_radar_preview()
		tower_info = tower_info.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	else: 
		push_warning("no foundation for CostButtonInfo_Tower")
		_radar_preview = null

func on_mouse_entered() -> void:
	if _radar_preview:
		_radar_preview.set_preview(tower_info)

func on_mouse_exited() -> void:
	if _radar_preview:
		_radar_preview.cancle_preview()

func get_tower_type() -> TowerInfo.TowerType: return tower_info.my_type

func has_missing_dependency() -> bool: return _get_unlock_status() != GlobalUnlocks.UnlockStatus.AVAILABLE

func _get_unlock_status() -> GlobalUnlocks.UnlockStatus:
	if _unlock_status == GlobalUnlocks.UnlockStatus.UNKNOWN:
		_unlock_status = TowerInfo.get_tower_unlock_statis(get_tower_type())
	return _unlock_status
