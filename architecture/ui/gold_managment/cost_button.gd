class_name CostButton extends Control

const SCENE_PATH = "uid://citf0bjrmxl7k"
const COLOR = "color"
const LABEL = "label"
const VALUE = "value"

enum PurchaseTypes { INFORMATION = 0, ONE_SHOT = 1, UPGRADE = 2, PROFIT = 3}

var _info : CostButtonInfo
@onready var _button: ButtonEnhanced = %Button
@onready var rich_text_label: RichTextLabel = %RichTextLabel
@onready var type_icon: TextureRect = %TypeIcon
@onready var coin_icon: TextureRect = %CoinIcon
@onready var level_label: Label = %LevelLabel

func _ready() -> void:
	_button.pressed.connect(_on_pressed)
	_button.mouse_entered.connect(_on_mouse_entered)
	_button.mouse_exited.connect(_on_mouse_exited)
	GoldManager.get_instance().gold_changed.connect(_on_gold_change)
	_update_display()
	pivot_offset = size * .5

func deactivate() -> void: set_info(null)

func set_info(info: CostButtonInfo) -> void:
	if _info == info:
		_update_display()
		return
	if _info:
		if _info.changed.is_connected(_update_display):
			_info.changed.disconnect(_update_display)
	_info = info
	if _info:
		if _info.changed.is_connected(_update_display):
			push_warning("CostButton managing signal is failing")
		else:
			_info.changed.connect(_update_display)
	_update_display()

func _on_pressed() -> void:
	if _info:
		_info.on_pressed()

func _on_mouse_entered() -> void: 
	if _info:
		_info.on_mouse_entered()

func _on_mouse_exited() -> void: 
	if _info:
		_info.on_mouse_exited()

func get_cost() -> float:
	if _info:
		return _info.get_cost()
	return 0.0

func get_label() -> String: 
	if _info:
		return _info.get_label()
	return ""

func set_type_icon(texture: Texture2D) -> void: type_icon.set_texture(texture)

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
	rich_text_label.set_text(_text)
	if _get_level() > -1: 
		level_label.show()
		level_label.set_text(str(_get_level()))
	else:
		level_label.hide()
	if _info.get_purchase_type() == CostButton.PurchaseTypes.INFORMATION:
		_button.set_state(ButtonEnhanced.ButtonStates.Inactive_Hidden)
	else: 
		if _can_afford():
			_button.set_state(ButtonEnhanced.ButtonStates.Active)
		else:
			_button.set_state(ButtonEnhanced.ButtonStates.Active_Overwrite)
	type_icon.set_texture(_info.primary_icon)
	coin_icon.set_texture(CoinTextures.get_coin_texture(_info.get_purchase_type(), _can_afford()) )
	_button.set_tooltip_text(_info.get_tooltip())

func _get_level() -> int: return _info.get_level()

func _get_cost_color() -> Color:
	if _can_afford():
		return Color.GREEN
	return Color.RED

func _on_gold_change() -> void: _update_display.call_deferred()
