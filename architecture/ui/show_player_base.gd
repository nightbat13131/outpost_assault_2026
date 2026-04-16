class_name DisplayPlayerBase extends VBoxContainer

static var _instance: DisplayPlayerBase

@onready var health_ui: HealthUI = $BaseHP/HealthUI

func _ready() -> void:
	_instance = self

func _connect_base(node: Object) -> void:
	if node is PlayerOutpost2D or node is PlayerOutpost3D:
		if node:
			health_ui.set_health_info(node.get_health_info())
	else:
		push_error(node, " send to DisplayPlayerBase._connect_base instead of a PlayerOutpost")

static func get_instance() -> DisplayPlayerBase: return _instance

static func connect_base(base: Object) -> void: 
	
	if base is PlayerOutpost2D or base is PlayerOutpost3D:
		if _instance: 
			_instance._connect_base(base)
	else:
		push_error(base, " send to DisplayPlayerBase.connect_base instead of a PlayerOutpost")
