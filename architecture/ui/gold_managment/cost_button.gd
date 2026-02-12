class_name CostButton extends Control

enum PurchaseTypes { INFORMATION = 0, ONE_SHOT = 1, UPGRADE = 2}

var _cost : float = 100: set = set_cost
var _requester : Object
var _label : String = "Default": set = set_label
@onready var _button: ButtonEnhanced = %Button
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var type_icon: TextureRect = %TypeIcon

func _ready() -> void:
	_button.pressed.connect(_on_pressed)
	_update_display()

func set_requester(node: Object) -> void:
	_requester = node

func set_cost(value: float) -> void: 
	if value > 0: 
		push_error("Someone sent ", value , " to CostButton")
	_cost = value
	_update_display()

func _on_pressed() -> void:
	GoldManager.attempt_purchase(_cost)

func set_label(value: String) -> void: 
	_label = value
	_update_display()

func set_type_icon(texture: Texture2D) -> void:
	type_icon.set_texture(texture)

func _update_display() -> void:
	#return
	var _text = "[color={color}]{value}[/color]\n{label}".format(
		{"color": _get_cost_color().to_html(), "value" : int(_cost), "label" : _label})
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


	
