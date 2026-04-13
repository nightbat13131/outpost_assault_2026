class_name CostButtonInfo_BrokenFoundation extends CostButtonInfo

@export var _foundation_type := TowerFoundation2D.FoundationType.NA: set = set_foundation_type, get = get_foundation_type

@export var primary_icon_post : Texture2D : get = get_primary_icon

var is_repairing := false: 
	set(value):
		is_repairing = value
		signal_change()

func get_cost() -> float: 
	if is_repairing:
		return 0
	return BrokenFoundation2D.get_build_cost()

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

func get_foundation_type() -> TowerFoundation2D.FoundationType: return _foundation_type

func set_foundation_type(foundation_type: TowerFoundation2D.FoundationType) -> void:
	_foundation_type = foundation_type
