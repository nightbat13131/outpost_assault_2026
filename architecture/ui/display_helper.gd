class_name DisplayHelper extends Resource

signal process_update

static var DEFAULT_POS = Vector2.INF

var _parent : Object
var _health_ui : HealthUI
var _position : Vector2 = DEFAULT_POS
var _purchaser_0 : PurchaseManager
var _purchaser_1 : PurchaseManager

func get_display_name() -> String:
	if _parent:
		return str(_parent.name)
	return "No Selection"

func _init(parent: Object, health_ui: HealthUI, purchaser_0: PurchaseManager, purchaser_1: PurchaseManager) -> void:
	_parent = parent
	_health_ui = health_ui
	if _parent:
		_position = _parent.get_position()
	_purchaser_0 = purchaser_0
	_purchaser_1 = purchaser_1

# So that towers can swap out IDs
func update_health_ui(ui: HealthUI) -> void: 
	_health_ui = ui
	process_update.emit()

func get_parent() -> Object: return _parent

func get_health_ui() -> HealthUI: return _health_ui

func get_camera_position() -> Vector2: return _position
