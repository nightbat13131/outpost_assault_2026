class_name Tower extends Area2D

signal dead(tower: Tower) ## I don't think the foundation cares between sold and destroyed.
#signal health_changed

@export var _tower_info : TowerInfo: get = _get_tower_info

var _health_info : HealthInfo: get = get_health_info

@onready var _tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _context_manager: TowerContextManager = %TowerContextManager
var _founation_upgrades : FoundationUpgrades

func _ready() -> void:
	#_health_info = HealthInfo.new()
	get_health_info().die.connect(_die)
	# _tower_info = _tower_info.duplicate() # called in pre-ready setup
	#_tower_info.set_health_info(_health_info)
	#_health_info.set_max_health(_tower_info.get_max_health(), true)
	_tower_purchase_manager.set_foundation(get_foundation())
	_context_manager.set_tower(self)
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)

func get_health_info() -> HealthInfo: return _tower_info.get_health_info()

func _get_tower_info() -> TowerInfo: return _tower_info

func _get_cost() -> float: return _get_tower_info().get_cost()

func get_reload_info() -> ReloadInfo: return _tower_info.get_reload_info()

func setup(upgrades: FoundationUpgrades, health_ui: HealthUI, _clip_reload_ui: ClipReloadUI) -> void:
	_tower_info = _tower_info.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	_tower_info.post_duplication()
	_founation_upgrades = upgrades
	_founation_upgrades.changed.connect(_on_upgrade_changed)
	_get_tower_info().set_upgrade_info(_founation_upgrades)
	_deffered_setup.call_deferred(health_ui)

func _deffered_setup(health_ui) -> void:
	health_ui.set_health_info(get_health_info())
	_on_upgrade_changed.call_deferred()

func repair() -> void: _health_info.full_heal()

func get_radar_shape() -> RadarShapeInfo: return _get_tower_info().get_radar_shape()

func get_repair_cost() -> float: return _get_tower_info().get_repair_value()

func get_display_name() -> String: return _get_tower_info().get_display_name()

func take_damage(damage_delt: float) -> void: _health_info.take_damage(damage_delt)

func has_shooter() -> bool: return false

func _on_upgrade_changed() -> void: pass

func sell() -> void:
	GoldManager.earn_gold(get_sell_value())
	dead.emit(self)
	queue_free()

func get_sell_value() -> float: return _get_tower_info().get_sell_value()

func get_foundation() -> TowerFoundation: 
	if _founation_upgrades:
		return _founation_upgrades.get_foundation()
	return null

func being_replaced() -> void: queue_free()

func _die() -> void:
	#TODO : Explode
	queue_free()
	dead.emit(self)

func get_purchase_manager() -> PurchaseManager: return _tower_purchase_manager

func get_context_manager() -> TowerContextManager: return _context_manager

static func get_scene_path() -> String: return "Method needs overriting missing"
