class_name CostButtonInfo extends Resource

# @export var current_level := -1 
@export var cost: float = 100 : get = get_cost
@export var label : String = "_Default_" : get = get_label
@export var tool_tip: String = "_Tooltip" : get = get_tooltip
@export var primary_icon : Texture2D : get = get_primary_icon
@export var purchase_type := CostButton.PurchaseTypes.UPGRADE : get = get_purchase_type
var parent_node : PurchaseManager #Object

func _init() -> void: pass

func get_cost() -> float: return cost

func get_label() -> String: return label

func get_tooltip() -> String: return tool_tip

func get_primary_icon() -> Texture2D: return primary_icon

func get_purchase_type() -> CostButton.PurchaseTypes: return purchase_type

func get_level() -> int: return -1

func set_purchase_manager(purchase_manager: PurchaseManager) -> void: parent_node = purchase_manager
