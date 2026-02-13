class_name PurchaseUISection extends VBoxContainer

@onready var cost_buttons: HolderCostButtons = %CostButtons
@onready var purchase_interface_label: Label = %PurchaseInterfaceLabel

func _ready() -> void:
	disable()

func set_title(text: String) -> void:
	purchase_interface_label.set_text(text)
	if text:
		purchase_interface_label.show()
	else:
		purchase_interface_label.hide()

func get_buttons(count: int) -> Array[CostButton]: 
	show()
	return cost_buttons.get_buttons(count)

func disable() -> void:
	cost_buttons.disable()
	hide()
