class_name RepairPurchaser extends PurchaseManager

signal start_repair

@export_category("CostButton")
@export var _cost_before_purchase: CostButtonInfo
@export var _cost_after_purchase: CostButtonInfo
var _is_repairing: bool = false

func _ready() -> void:
	_cost_after_purchase = _cost_after_purchase.duplicate()
	_cost_after_purchase.parent_node = self
	_cost_before_purchase = _cost_before_purchase.duplicate()
	_cost_before_purchase.parent_node = self

func on_select() -> void:
	_get_buttons(1)
	_update_buttons()

func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void:
	if is_successful and info == _cost_before_purchase:
		_is_repairing = true
		start_repair.emit()
	_update_buttons()

func _update_buttons() -> void:
	if !_buttons.is_empty():
		if _is_repairing:
			_buttons[0].set_info(_cost_after_purchase)
		else:
			_buttons[0].set_info(_cost_before_purchase)
