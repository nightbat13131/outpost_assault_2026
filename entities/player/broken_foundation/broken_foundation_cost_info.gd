class_name CostButtonInfo_BrokenFoundation extends CostButtonInfo

@export var primary_icon_post : Texture2D : get = get_primary_icon

var _is_repaired := false

func repair_started() -> void: _is_repaired = true

func get_cost() -> float: 
	if _is_repaired:
		return 0
	return 100

func get_label() -> String: 
	if _is_repaired:
		return "Rebuilding"
	return "Rebuild"

func get_tooltip() -> String: 
	if _is_repaired:
		return "Rebuild in progress."
	return "Rebuild Ruble into Tower Foundation."

func get_primary_icon() -> Texture2D: 
	if _is_repaired:
		return primary_icon_post
	return primary_icon

func get_purchase_type() -> CostButton.PurchaseTypes:
	if _is_repaired:
		return CostButton.PurchaseTypes.INFORMATION
	return CostButton.PurchaseTypes.ONE_SHOT

func get_level() -> int: return -1
