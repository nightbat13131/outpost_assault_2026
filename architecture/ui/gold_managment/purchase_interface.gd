class_name PurchaseInterface extends VBoxContainer

@onready var purchase_interface_label: Label = %PurchaseInterfaceLabel
@onready var cost_buttons: HolderCostButtons = %CostButtons

func interface_this(node: Object) -> void:
	if node:
		show()
	else:
		hide()
