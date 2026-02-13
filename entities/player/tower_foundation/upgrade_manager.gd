class_name UpgradeManager extends Node

@export var cost_upgrade_radio: CostButtonInfo
@export var cost_upgrade_gear: CostButtonInfo
@export var cost_upgrade_cooling: CostButtonInfo

var _buttons : Array[CostButton] = []

func on_selected() -> void:
	var purchase_ui : PurchaseInterface = PurchaseInterface.get_instance()
	var purchase_section : PurchaseUISection
	if purchase_ui: 
		purchase_section = purchase_ui.request_sections(1)[0]
		purchase_section.set_title("Foundation Upgrades")
		_buttons = purchase_section.get_buttons(3)
	_update_buttons()

func _update_buttons() -> void:
	if _buttons.size() != 3:
		push_warning("Upgrade Manager has wrong number of buttons")
		return 
	_buttons[0].set_info(cost_upgrade_cooling)
	_buttons[1].set_info(cost_upgrade_gear)
	_buttons[2].set_info(cost_upgrade_radio)
