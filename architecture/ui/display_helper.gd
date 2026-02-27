class_name DisplayHelper extends Resource

signal process_update
signal unselected

static var DEFAULT_POS = Vector2.INF

var _parent : Object
var _display_name : String = ''
#var _health_ui : HealthUI
var _health_info: HealthInfo
var _reload_info : ReloadInfo
var _position : Vector2 = DEFAULT_POS
var _purchaser_0 : PurchaseManager
var _purchaser_1 : PurchaseManager
var _tower :Tower

func set_display_name(text: String) -> void: _display_name = text

func get_display_name() -> String:
	if _display_name.length() > 0:
		return _display_name
	elif _parent:
		return str(_parent.name)
	return "No Selection"

func get_purchaser(index: int) -> PurchaseManager:
	match index:
		0: 
			return _purchaser_0
		1:
			return _purchaser_1
		_:
			push_error("DisplayHelper.get_purchaser was sent out of bounds index ", index )
			return null

func set_purchaser(purchaser: PurchaseManager, index: int) -> void:
	match index:
		0: 
			_purchaser_0 = purchaser
		1:
			_purchaser_1 = purchaser
		_:
			push_error("DisplayHelper.set_purchaser was sent out of bounds index ", index, " for ", purchaser )

func _init(parent: Object, health_info: HealthInfo, purchaser_0: PurchaseManager, purchaser_1: PurchaseManager) -> void:
	_parent = parent
	#_health_ui = health_ui
	_health_info = health_info
	if _parent:
		_position = _parent.get_global_position()
	_purchaser_0 = purchaser_0
	_purchaser_1 = purchaser_1

# So that foundations can swap out towers
func set_tower(tower: Tower) -> void:
	_tower = tower
	process_update.emit()

func set_reload_info(reload_info: ReloadInfo) -> void: _reload_info = reload_info

func get_tower() -> Tower: return _tower

func get_parent() -> Object: return _parent

func get_health_info() -> HealthInfo: 
	if _tower:
		return _tower.get_health_info()
	return _health_info

func get_camera_position() -> Vector2: return _position

func get_reload_info() -> ReloadInfo: return _reload_info

func get_tower_context_manager() -> TowerContextManager:
	if _tower:
		return _tower.get_context_manager()
	return null

func selection_ended() -> void: unselected.emit()
