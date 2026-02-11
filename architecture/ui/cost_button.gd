class_name CostButton extends Control

var _cost : float = 100: set = set_cost
var _requester : Object
var _lable : String = "Default": set = set_lable
@onready var _button: ButtonEnhanced = %Button
@onready var rich_text_label: RichTextLabel = %RichTextLabel

func _ready() -> void:
	_button.pressed.connect(_on_pressed)
	_update_display()

func set_cost(value: float) -> void: 
	if value > 0: 
		push_error("Someone sent ", value , " to CostButton")
	_cost = value
	_update_display()

func _on_pressed() -> void:
	GoldManager.attempt_purchase(_cost)

func set_lable(value: String) -> void: 
	_lable = value
	_update_display()

func _update_display() -> void:
	#return
	var _text = "[color={}]{}[/color]\n{}".format([_get_cost_color().to_html(), int(_cost), _lable], "{}")
	print(_text)
	rich_text_label.set_text(_text)

func _get_cost_color_() -> String:
	if GoldManager.get_gold() >= _cost:
		return "green"
	return "red"


func _get_cost_color() -> Color:
	if GoldManager.get_gold() >= _cost:
		return Color.GREEN
	return Color.RED
