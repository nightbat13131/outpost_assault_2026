@abstract
class_name PurchaseManager extends Node

var _buttons : Array[CostButton] = []

@export var section_name := "Section Unnamed"
@abstract func on_select() -> void
@abstract func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void
@abstract func _update_buttons() -> void


var _purchase_ui : PurchaseInterface 
var _purchase_section : PurchaseUISection

func _get_buttons(count: int, section_index: = 0) -> void:
	if _purchase_ui == null:
		_purchase_ui = PurchaseInterface.get_instance()
		if _purchase_ui == null:
			push_error("Getting a _purchase_ui failed")
			return
	if _purchase_section == null:
		_purchase_section = _purchase_ui.request_section(section_index)
		if _purchase_section == null:
			push_error("Getting a _purchase_section failed")
			return
	_purchase_ui.show()
	_purchase_section.set_title(section_name)
	_buttons = _purchase_section.get_buttons(count)
