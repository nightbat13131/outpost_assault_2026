class_name RepairPurchaser extends PurchaseManager

signal start_repair

var _cost_info : CostButtonInfo_BrokenFoundation
var _broken_foundation: BrokenFoundation

func set_cost_info(info: CostButtonInfo_BrokenFoundation) -> void:
	_cost_info = info
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
	if _broken_foundation:
		_cost_info.is_repairing = _broken_foundation.is_repairing()
	if !_buttons.is_empty():
		_buttons[0].set_info(_cost_info)

func get_foundation_type() -> TowerFoundation.FoundationType: return _cost_info.get_foundation_type()

func set_foundation_type(foundation_type: TowerFoundation.FoundationType) -> void:
	if foundation_type == get_foundation_type():
		#no change needed
		return
	_cost_info = _cost_info.duplicate()
	_cost_info.set_foundation_type(foundation_type)
