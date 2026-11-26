class_name PurchaseManager_Outpost extends PurchaseManager

@export var cost_upgrade_infos : Array[CostButtonInfo_OutpostUpgrades] = []

var _upgrade_info : PlayerOutpostUpgrades = null : set = set_upgrade_info

func _ready() -> void:
	_validate_infos()

func _validate_infos() -> void:
	## if towers become unlockable during levels instead of between, consider a used list vs an initial list. 
	var availability: GlobalUnlocks.UnlockStatus
	var _holder : Array[CostButtonInfo_OutpostUpgrades]
	for index in range(cost_upgrade_infos.size()):
		availability = GlobalUnlocks.get_player_outpost_upgrade_unlock_status(cost_upgrade_infos[index].get_upgrade_type())
		if availability != GlobalUnlocks.UnlockStatus.HIDDEN:
			_holder.append(cost_upgrade_infos[index].duplicate())
			_holder[-1].set_purchase_manager(self)
	cost_upgrade_infos = _holder

func _connect_to_section() -> void:
	_get_buttons(cost_upgrade_infos.size())
	_update_buttons()

func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void : 
	if !is_successful:
		return
	_upgrade_info.attempt_upgrade_request(info)
	_update_buttons() 

func _update_buttons() -> void : 
	if _buttons.size() != cost_upgrade_infos.size():
		push_warning("Upgrade Manager has wrong number of buttons")
		return 
	for index in range(cost_upgrade_infos.size()):
		_buttons[index].set_info(cost_upgrade_infos[index])
		cost_upgrade_infos[index].set_purchase_manager(self)
		cost_upgrade_infos[index].set_upgrade_info(_upgrade_info)

func set_upgrade_info(info: PlayerOutpostUpgrades) -> void:
	_upgrade_info = info
	for index in range(cost_upgrade_infos.size()):
		#cost_upgrade_infos[index] = cost_upgrade_infos[index].duplicate()
		cost_upgrade_infos[index].set_purchase_manager(self)
		cost_upgrade_infos[index].set_upgrade_info(_upgrade_info)

func get_upgrade_info() -> PlayerOutpostUpgrades: return _upgrade_info
