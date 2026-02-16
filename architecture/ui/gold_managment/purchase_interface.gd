class_name PurchaseInterface extends VBoxContainer

@onready var purchase_interface_section_0: PurchaseUISection = %PurchaseInterfaceSection_0
@onready var purchase_interface_section_1: PurchaseUISection = %PurchaseInterfaceSection_1

static var _instance : PurchaseInterface

func _ready() -> void:
	_instance = self

func hide_section(index: int) -> void:
	match index:
		0:
			purchase_interface_section_0.hide()
		1: 
			purchase_interface_section_1.hide()
		_:
			push_warning("hide_section sent for index of ", index)

func request_section(index: int = 0) -> PurchaseUISection:
	match index:
		0:
			show()
			return purchase_interface_section_0
		1: 
			show()
			return purchase_interface_section_1
		_:
			push_warning("Need to be able to request_sections for index of ", index)
			return null

static func get_instance() -> PurchaseInterface:
	if _instance:
		return _instance
	return null

static func disable() -> void:
	if _instance:
		_instance.purchase_interface_section_0.disable()
		_instance.hide()
