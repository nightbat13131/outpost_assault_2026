@abstract
class_name PurchaseManager extends Node

var _buttons : Array[CostButton] = []

@export var section_name := "Section Unnamed"

var _purchase_section : PurchaseUISection

@abstract func _connect_to_section() -> void
@abstract func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void
@abstract func _update_buttons() -> void

func connect_to_section(section: PurchaseUISection) -> void:
	_purchase_section = section
	_connect_to_section()

func get_section_title() -> String: return section_name

func _get_buttons(count: int) -> void:
	_purchase_section.set_title(section_name)
	_buttons = _purchase_section.get_buttons(count)
