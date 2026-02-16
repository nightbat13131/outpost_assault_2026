class_name CostButtonInfo_Tower extends CostButtonInfo

@export var tower_type: Tower.TowerType

func get_cost() -> float: return Tower.get_tower_cost(tower_type)

func get_label() -> String: return Tower.get_display_name(tower_type)

func get_tooltip() -> String: return super.get_tooltip()
