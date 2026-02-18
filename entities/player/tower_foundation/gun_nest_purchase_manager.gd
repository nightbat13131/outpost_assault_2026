class_name PurchaseManager_GunNest extends PurchaseManager

@export var cost_tower_infos : Array[CostButtonInfo_Tower]
var _foundation : TowerFoundation

func _ready() -> void:
	for index in range(cost_tower_infos.size()):
		cost_tower_infos[index] = cost_tower_infos[index].duplicate()
		cost_tower_infos[index].set_purchase_manager(self)

func _connect_to_section() -> void:
	_get_buttons(cost_tower_infos.size())
	_update_buttons()

func set_foundation(node: TowerFoundation) -> void:
	_foundation = node
	for index in range(cost_tower_infos.size()):
		cost_tower_infos[index].set_radar(_foundation.get_radar())

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
		_foundation.add_tower(info.tower_type)
#		_update_buttons()
