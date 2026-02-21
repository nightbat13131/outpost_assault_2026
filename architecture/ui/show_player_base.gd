class_name DisplayPlayerBase extends VBoxContainer

static var _instance: DisplayPlayerBase

@onready var health_ui: ShadowHealthUI = $BaseHP/HealthUI

func _ready() -> void:
	_instance = self

func connect_base(node: PlayerMainBase) -> void:
	if node:
		health_ui.set_primary(node.get_health_ui())

static func get_instance() -> DisplayPlayerBase: return _instance
