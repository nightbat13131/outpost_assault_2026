class_name UpgradeManager_TowerFoundation extends PurchaseManager

@export var cost_upgrade_infos : Array[CostButonInfo_FoundationUpgrads]

var _upgrade_info : FoundationUpgrades

func set_upgrade_info(info: FoundationUpgrades) -> void:
	_upgrade_info = info
	for index in range(cost_upgrade_infos.size()):
		cost_upgrade_infos[index] = cost_upgrade_infos[index].duplicate()
		cost_upgrade_infos[index].set_purchase_manager(self)
		cost_upgrade_infos[index].set_upgrade_info(_upgrade_info)
		

func on_select() -> void:
	_get_buttons(cost_upgrade_infos.size())
	_update_buttons()

func _update_buttons() -> void:
	if _buttons.size() != cost_upgrade_infos.size():
		push_warning("Upgrade Manager has wrong number of buttons")
		return 
	for index in range(cost_upgrade_infos.size()):
		_buttons[index].set_info(cost_upgrade_infos[index])

func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void:
	if !is_successful:
		return
	_upgrade_info.attempt_upgrade_request(info)
	_update_buttons() 
