class_name PurchaseManager_GunNest extends PurchaseManager

@export var cost_tower_infos : Array[CostButtonInfo_Tower]
var _foundation : TowerFoundation

func _ready() -> void:
	_validate_infos()

func _validate_infos() -> void:
	## if towers become unlockable during levels instead of between, consider a used list vs an initial list. 
	var availability: GlobalUnlocks.UnlockStatus
	for index in range(cost_tower_infos.size()):
		availability = TowerInfo.get_tower_unlock_statis(cost_tower_infos[index].get_tower_type())
		if availability == GlobalUnlocks.UnlockStatus.HIDDEN:
			cost_tower_infos[index] = null
		else:
			cost_tower_infos[index] = cost_tower_infos[index].duplicate()
			cost_tower_infos[index].set_purchase_manager(self)
	while cost_tower_infos.has(null):
		cost_tower_infos.erase(null)

func _connect_to_section() -> void:
	_get_buttons(cost_tower_infos.size())
	_update_buttons()

func set_foundation(node: TowerFoundation) -> void:
	_foundation = node
	for index in range(cost_tower_infos.size()):
		#cost_tower_infos[index].set_radar_preview(_foundation.get_radar_preview())
		cost_tower_infos[index].set_foundation(_foundation)

func _update_buttons() -> void:
	if _buttons.size() != cost_tower_infos.size():
		push_warning("Upgrade Manager has wrong number of buttons")
		return 
	for index in range(cost_tower_infos.size()):
		_buttons[index].set_info(cost_tower_infos[index])

func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void:
	if !is_successful:
		return
	if info is CostButtonInfo_Tower: #cast for autocomplete
		_foundation.add_tower(info.get_tower_type())
