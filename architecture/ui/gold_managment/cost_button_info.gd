class_name CostButtonInfo extends Resource

@export var current_level := -1 
@export var cost: float = 100
@export var label : String = "_Default_"
@export var tool_tip: String = "_Tooltip"
@export var primary_icon : Texture2D
@export var purchase_type := CostButton.PurchaseTypes.UPGRADE
var parent_node : Object

func _init() -> void: pass
