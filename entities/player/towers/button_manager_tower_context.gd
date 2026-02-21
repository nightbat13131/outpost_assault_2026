class_name TowerContextManager extends PurchaseManager

@export var _repair_info :CostBottonInfo_Tower_RepairSell
@export var _sell_info :CostBottonInfo_Tower_RepairSell
var _tower : Tower

func _ready() -> void:
	if _repair_info:
		_repair_info = _repair_info.duplicate()
		_repair_info.set_purchase_manager(self)
	if _sell_info:
		_sell_info = _sell_info.duplicate()
		_sell_info.set_purchase_manager(self)

func set_tower(tower: Tower) -> void:
	_tower = tower
	if _repair_info:
		_repair_info.set_tower(_tower)
	if _sell_info:
		_sell_info.set_tower(_tower)

func _connect_to_section() -> void:
	
	pass

func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void:
	if !is_successful: 
		return
	if info == get_repair_info():
		_tower.repair()
	elif info == get_sell_info():
		_tower.sell()


func _update_buttons() -> void:
	
	pass

func get_repair_info() -> CostBottonInfo_Tower_RepairSell: return _repair_info

func get_sell_info() -> CostBottonInfo_Tower_RepairSell: return _sell_info
