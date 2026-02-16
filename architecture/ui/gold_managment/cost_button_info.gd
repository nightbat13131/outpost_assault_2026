@abstract
class_name CostButtonInfo extends Resource

@export var primary_icon : Texture2D : get = get_primary_icon
var parent_node : PurchaseManager: set = set_purchase_manager

func set_purchase_manager(purchase_manager: PurchaseManager) -> void: parent_node = purchase_manager

func get_cost() -> float: return -1

func get_label() -> String: return "_Default_"

func get_tooltip() -> String: return "_Default_Tooltip_"

func get_primary_icon() -> Texture2D: return primary_icon

func get_purchase_type() -> CostButton.PurchaseTypes: return CostButton.PurchaseTypes.ONE_SHOT

func get_level() -> int: return -1
