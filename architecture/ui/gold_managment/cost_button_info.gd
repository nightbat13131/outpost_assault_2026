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

func has_missing_dependency() -> bool: return false

func on_mouse_entered() -> void: pass

func on_mouse_exited() -> void: pass

func on_pressed() -> void:
	if get_purchase_type() == CostButton.PurchaseTypes.INFORMATION:
		return
	if parent_node:
		var purchase_result = GoldManager.attempt_purchase(get_cost())
		if purchase_result:
		# func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void:
		#if _info.parent_node.has_method("purchase_attempt_result"):
			parent_node.purchase_attempt_result(purchase_result, self)
		#else:
		#	push_warning("CostButton info parent (" + _info.parent_node.name + ") does not have purchase_attempt_result")

func signal_change() -> void: changed.emit()
