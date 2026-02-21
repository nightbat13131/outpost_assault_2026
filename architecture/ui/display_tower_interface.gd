class_name DisplayTowerInterface extends VBoxContainer

@onready var _repair_button: CostButton = %Repair
@onready var _sell_button: PanelContainer = %Sell

#var _tower : Tower

func set_manager(manager: TowerContextManager) -> void:
	if manager == null:
		disable()
		return
	_repair_button.set_info(manager.get_repair_info())
	_sell_button.set_info(manager.get_sell_info())
	show()

func disable() -> void:
	_repair_button.set_info(null)
	_sell_button.set_info(null)
	hide()
