class_name CostButtonInfo_BrokenFoundation extends CostButtonInfo

@export var primary_icon_post : Texture2D : get = get_primary_icon

var is_repairing := false

#func repair_started() -> void: _is_repaired = true

func get_cost() -> float: 
	if is_repairing:
		return 0
	return BrokenFoundation.get_build_cost()

func get_label() -> String: 
	if is_repairing:
		return "Rebuilding"
	return "Rebuild"

func get_tooltip() -> String: 
	if is_repairing:
		return "Rebuild in progress."
	return "Rebuild Ruble into Tower Foundation."

func get_primary_icon() -> Texture2D: 
	if is_repairing:
		return primary_icon_post
	return primary_icon

func get_purchase_type() -> CostButton.PurchaseTypes:
	if is_repairing:
		return CostButton.PurchaseTypes.INFORMATION
	return CostButton.PurchaseTypes.ONE_SHOT

func get_level() -> int: return -1
