class_name CostButton extends Control

const SCENE_PATH = "uid://citf0bjrmxl7k"
const COLOR = "color"
const LABEL = "label"
const VALUE = "value"

enum PurchaseTypes { INFORMATION = 0, ONE_SHOT = 1, UPGRADE = 2}

var _info : CostButtonInfo
@onready var _button: ButtonEnhanced = %Button
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var type_icon: TextureRect = %TypeIcon
@onready var coin_icon: TextureRect = %CoinIcon
@onready var level_label: Label = %LevelLabel

func _ready() -> void:
	_button.pressed.connect(_on_pressed)
	GoldManager.get_instance().gold_changed.connect(_on_gold_change)
	_update_display()

func deactivate() -> void:
	set_info(null)
	pass

func set_info(info: CostButtonInfo) -> void:
	_info = info
	_update_display()

func _on_pressed() -> void:
	if _info.parent_node:
		var purchase_result = GoldManager.attempt_purchase(get_cost())
		# func purchase_attempt_result(is_successful : bool, info: CostButtonInfo) -> void:
		if _info.parent_node.has_method("purchase_attempt_result"):
			_info.parent_node.purchase_attempt_result(purchase_result, _info)
		else:
			push_warning("CostButton info parent (" + _info.parent_node.name + ") does not have purchase_attempt_result")

func get_cost() -> float:
	if _info:
		return _info.cost
	return 0.0

func get_label() -> String: 
	if _info:
		return _info.label
	return ""

func set_type_icon(texture: Texture2D) -> void:
	type_icon.set_texture(texture)

func _can_afford() -> bool: return GoldManager.get_gold() >= get_cost()

func _update_display() -> void:
	if _info == null:
		hide()
		return
	show()
	var args = {COLOR: _get_cost_color().to_html(), VALUE : int(get_cost()), LABEL : get_label()}
	var _text = str("[color={"+COLOR+"}]{"+VALUE+"}[/color]\n{"+LABEL+"}").format(args)
	if args[VALUE] <= 0:
		_text = str("{"+LABEL+"}").format(args)
	print(_text)
	level_label.set_text(str(_get_level()))
	if _get_level() > -1: 
		level_label.show()
	else:
		level_label.hide()
	rich_text_label.set_text(_text)
	type_icon.set_texture(_info.primary_icon)
	coin_icon.set_texture( CoinTextures.get_coin_texture(_info.purchase_type, _can_afford()) )

func _get_level() -> int: return _info.current_level

func _get_cost_color() -> Color:
	if _can_afford():
		return Color.GREEN
	return Color.RED

func _on_gold_change() -> void: _update_display()
