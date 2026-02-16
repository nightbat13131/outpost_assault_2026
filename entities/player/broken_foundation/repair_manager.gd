class_name RepairPurchaser extends PurchaseManager

signal start_repair

@export_category("CostButton")
@export var _cost_info: CostButtonInfo_BrokenFoundation
var _is_repairing: bool = false

func _ready() -> void:
	_cost_info = _cost_info.duplicate()
	_cost_info.set_purchase_manager(self)

func on_select() -> void:
	hide_section()
	_get_buttons(1)
	_update_buttons()

func purchase_attempt_result(is_successful : bool, _info: CostButtonInfo) -> void:
	if is_successful: # and info == _cost_before_purchase:
		_cost_info.repair_started()
		#_is_repairing = true
		start_repair.emit()
	_update_buttons()

func _update_buttons() -> void:
	if !_buttons.is_empty():
		_buttons[0].set_info(_cost_info)
		return
