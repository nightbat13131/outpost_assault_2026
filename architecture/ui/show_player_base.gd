class_name DisplayPlayerBase extends VBoxContainer

static var _instance: DisplayPlayerBase

@onready var health_ui: HealthUI = $BaseHP/HealthUI

func _ready() -> void:
	_instance = self

func _connect_base(node: PlayerOutpost) -> void:
	if node:
		health_ui.set_health_info(node.get_health_info())

static func get_instance() -> DisplayPlayerBase: return _instance

static func connect_base(base: PlayerOutpost) -> void: 
	if _instance: 
		_instance._connect_base(base)
