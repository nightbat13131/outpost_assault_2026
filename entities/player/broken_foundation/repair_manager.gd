class_name RepairPurchaser extends PurchaseManager

signal start_repair

@export_category("CostButton")
@export var _cost_info: CostButtonInfo_BrokenFoundation
var _broken_foundation: BrokenFoundation

func _ready() -> void:
	_cost_info = _cost_info.duplicate()
	_cost_info.set_purchase_manager(self)

func set_broken_foundation(broken_foundation: BrokenFoundation) -> void:
	_broken_foundation = broken_foundation

func _connect_to_section() -> void:
	_get_buttons(1)
	_update_buttons()

func purchase_attempt_result(is_successful : bool, _info: CostButtonInfo) -> void:
	if is_successful: # and info == _cost_before_purchase:
		start_repair.emit()
	_update_buttons()

func remote_update_buttons() -> void: _update_buttons()

func _update_buttons() -> void:
	_cost_info.is_repairing = _broken_foundation.is_repairing()
	if !_buttons.is_empty():
		_buttons[0].set_info(_cost_info)
