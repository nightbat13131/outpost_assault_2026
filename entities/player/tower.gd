@abstract
class_name Tower extends Area2D

signal dead(tower: Tower) ## I don't think the foundation cares between sold and destroyed.
signal health_changed

var _my_type := TowerInfo.TowerType.NA
var _max_hp :  float = 100
var _hp : float = 100: set = set_health
var _health_ui : HealthUI
var _tower_purchase_manager: PurchaseManager_GunNest
var _radar_sensor : RadarSensor
var _founation_upgrades : FoundationUpgrades
var _context_manager: TowerContextManager


@export_flags_2d_physics var _targets : int

func _ready() -> void:
	_mid_ready()
	set_max_health(TowerInfo.get_max_health(_my_type), true)
	for each_child in get_children():
		if each_child is PurchaseManager_GunNest:
			_tower_purchase_manager = each_child
			_tower_purchase_manager.set_foundation(get_foundation())
		if each_child is TowerContextManager: 
			_context_manager = each_child
			_context_manager.set_tower(self)

@abstract func _mid_ready() -> void

func setup(upgrades: FoundationUpgrades, radar_sensor: RadarSensor, health_ui) -> void:
	_founation_upgrades = upgrades
	_founation_upgrades.upgrade_change.connect(_on_upgrade_changed)
	_radar_sensor = radar_sensor
	_health_ui = health_ui
	if _health_ui:
		_hp = _hp
	if _radar_sensor:
		_radar_sensor.set_target_types(_targets)

func repair() -> void: set_health(_max_hp)

func get_repair_cost() -> float: return (1- get_health_ratio()) * TowerInfo.get_tower_cost(_my_type)

func set_max_health(max_hp: float, force_full:= false) -> void:
	if max_hp <= 0.0: 
		push_error(self, "Max health getting pushed a bad number ", max_hp)
		return
	_max_hp = max_hp
	if force_full:
		_hp = _max_hp
	else:
		_hp = _hp

func set_health(hp: float) -> void:
	_hp = hp
	health_changed.emit()
	if _health_ui:
		_health_ui.set_health_ratio(get_health_ratio())
	if _hp <= 0:
		_die()

func take_damage(damage_delt: float) -> void: _hp -= abs(damage_delt)

func get_health_ratio() -> float: return clamp(_hp / _max_hp, 0.0, 1.0)

func get_health_ui() -> HealthUI: return _health_ui

func _on_upgrade_changed() -> void:
	pass

func sell() -> void:
	GoldManager.earn_gold(get_sell_value())
	dead.emit(self)
	queue_free()

func get_sell_value() -> float: return get_health_ratio() * TowerInfo.get_tower_cost(_my_type)

func get_foundation() -> TowerFoundation: 
	if _founation_upgrades:
		return _founation_upgrades.get_foundation()
	return null

func _die() -> void:
	#TODO : Explode
	queue_free()
	dead.emit(self)

func get_purchase_manager() -> PurchaseManager: return _tower_purchase_manager

func get_context_manager() -> TowerContextManager: return _context_manager

static func get_scene_path() -> String: return "Method needs overriting missing"
