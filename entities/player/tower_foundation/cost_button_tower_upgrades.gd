class_name CostButonInfo_FoundationUpgrads extends CostButtonInfo

@export var _upgrade_type : FoundationUpgrades.UpgradeTypes
var _upgrade_info : FoundationUpgrades

func set_upgrade_info(info: FoundationUpgrades) -> void: _upgrade_info = info

func get_upgrade_type() -> FoundationUpgrades.UpgradeTypes: return _upgrade_type

func get_cost() -> float: 
	if _upgrade_info:
		return _upgrade_info.get_upgrade_cost(_upgrade_type)
	return super.get_cost()

func get_label() -> String: 
	if _upgrade_info:
		return FoundationUpgrades.upgrade_type_displaynames[_upgrade_type]
	return super.get_label()

func get_tooltip() -> String: 
	if _upgrade_info:
		return _upgrade_info.get_upgrade_tooltip(_upgrade_type)
	return super.get_tooltip()

func get_level() -> int:
	if _upgrade_info:
		return _upgrade_info.get_upgrade_level(_upgrade_type)
	return super.get_level()

func get_purchase_type() -> CostButton.PurchaseTypes:
	if _upgrade_info:
		if _upgrade_info.is_type_maxed(_upgrade_type):
			return CostButton.PurchaseTypes.INFORMATION
		return CostButton.PurchaseTypes.UPGRADE
	return super.get_purchase_type()
