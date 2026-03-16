class_name Tower extends Area2D

signal dead(tower: Tower) ## I don't think the foundation cares between sold and destroyed.

@export var _tower_info : TowerInfo: get = get_tower_info

@onready var _tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _context_manager: TowerContextManager = %TowerContextManager
var _founation_upgrades : FoundationUpgrades

func _ready() -> void:
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)

func get_health_info() -> HealthInfo: return _tower_info.get_health_info()

func get_tower_info() -> TowerInfo: return _tower_info

func _get_cost() -> float: return get_tower_info().get_cost()

func get_reload_info() -> ReloadInfo: return _tower_info.get_reload_info()

func setup(upgrades: FoundationUpgrades, health_ui: HealthUI, _clip_reload_ui: ClipReloadUI) -> void:
	#print("C 1")
	_tower_info = _tower_info.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	#print("C 2")
	_tower_info.post_duplication()
	#print("C 3")
	_tower_info.set_upgrade_info(upgrades)
	_context_manager.set_tower(self)
	_tower_purchase_manager.set_foundation(upgrades.get_foundation())
	health_ui.set_health_info(get_health_info())
	get_health_info().die.connect(_die)
	_clip_reload_ui.set_reload_info(get_reload_info())
	_on_upgrade_changed.call_deferred()
	#print("C 4")

func repair() -> void: get_health_info().full_heal()

func get_radar_shape() -> RadarShapeInfo: return get_tower_info().get_radar_shape()

func get_repair_cost() -> float: return get_tower_info().get_repair_value()

func get_display_name() -> String: return get_tower_info().get_display_name()

func take_damage(damage_delt: float) -> void: get_health_info().take_damage(damage_delt)

func has_shooter() -> bool: return false

func _on_upgrade_changed() -> void: pass

func sell() -> void:
	GoldManager.earn_gold(get_sell_value())
	dead.emit(self)
	queue_free()

func get_sell_value() -> float: return get_tower_info().get_sell_value()

func being_replaced() -> void: queue_free()

func _die() -> void:
	get_reload_info().die()
	#TODO : Explode
	queue_free()
	dead.emit(self)

func get_purchase_manager() -> PurchaseManager: return _tower_purchase_manager

func get_context_manager() -> TowerContextManager: return _context_manager

static func get_scene_path() -> String: return "Method needs overriting missing"

func set_parent_hovered(_is_hover: bool ) -> void: pass

func set_parent_selected(_is_selected: bool) -> void: pass
