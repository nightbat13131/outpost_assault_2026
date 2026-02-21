class_name CostBottonInfo_Tower_RepairSell extends CostButtonInfo

enum RepairSell {REPAIR = 0, SELL = 1}

@export var _mode := RepairSell.SELL
var _tower : Tower

func get_cost() -> float:
	if _tower == null: 
		return -1
	if _mode == RepairSell.REPAIR:
		return _tower.get_repair_cost()
	return _tower.get_sell_value()

func get_label() -> String:
	if _mode == RepairSell.REPAIR:
		return "Repair"
	return "Sell"

func get_tooltip() -> String:
	if _mode == RepairSell.REPAIR:
		return "Repair tower based on build cost and current health"
	return "Sell tower based on build cost and current health"

func set_tower(tower: Tower) -> void: 
	if _tower != null:
		print("turns out I need to disconect from tower")
	_tower = tower
	_tower.health_changed.connect(_on_health_changed)

func on_pressed() -> void:
	if _mode == RepairSell.REPAIR:
		super.on_pressed()
		return
	elif _mode == RepairSell.SELL:
		if parent_node:
			## GoldManager.earn_gold(get_cost()) ## tower calls the money gain
			parent_node.purchase_attempt_result(true, self)

func _on_health_changed() -> void: signal_update()
