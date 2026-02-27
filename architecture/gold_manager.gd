class_name GoldManager extends Control
## All mods to costs and gains are supposed to be calculated before sending the value to the GoldManager

signal gold_changed()

static var _instance

@onready var label_gold_value: Label = %GoldValue
var _gold := 1225.5 : set = _set_gold

func _ready() -> void:
	_instance = self
	set_gold(_gold)

func _set_gold(value: float) -> void:
	_gold = value
	gold_changed.emit()
	var display_value : String
	if _gold <= 0:
		display_value = "0"
	else: 
		display_value = str(int(_gold))
		# https://forum.godotengine.org/t/put-commas-into-a-number-gdscript/116184/3
		# add commas
		if len(display_value) > 3:
			var result := ""
			var count := 0
			for i in range(len(display_value) -1, -1, -1):
				result = display_value[i] + result
				count += 1
				if count % 3 == 0 and i != 0:
					result = "," + result ## TODO beware this symbol if you go multi language
			display_value = result
	label_gold_value.set_text(display_value)

func _attempt_purchase(cost: float) -> bool:
	if _gold < cost:
		return false
	_gold -= cost
	return true

static func get_gold() -> float:
	if get_instance():
		return get_instance()._gold
	return 0.0

static func get_instance() -> GoldManager: return _instance

static func set_gold(value: float) -> void:
	if _instance:
		_instance._set_gold(value)

static func attempt_purchase(cost : float) -> bool:
	if get_instance():
		return get_instance()._attempt_purchase(cost)
	return false

static func earn_gold(profit: float) -> void:
	if profit < 0:
		push_error("someone just send me nagative gold, fuck dude")
		return
	if _instance:
		_instance._gold += profit
