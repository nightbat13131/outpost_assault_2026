@abstract
class_name Tower extends Node2D

signal dead(tower: Tower) ## I don't think the foundation cares between sold and destroyed.
signal health_changed

var _my_type := TowerInfo.TowerType.NA
var _max_hp : float
var _hp : float: set = set_health
var _health_ui : HealthUI
var tower_purchase_manager: PurchaseManager_GunNest
var _radar_sensor : RadarSensor
var _founation_upgrades : FoundationUpgrades
@export_flags_2d_physics var _targets : int

func _ready() -> void:
	_mid_ready()
	set_max_health(TowerInfo.get_max_health(_my_type), true)
	for each_child in get_children():
		if each_child is PurchaseManager_GunNest:
			tower_purchase_manager = each_child
			tower_purchase_manager.set_foundation(get_foundation())
			return

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

func damange(damage_delt: float) -> void: _hp -= abs(damage_delt)

func get_health_ratio() -> float: return clamp(_hp / _max_hp, 0.0, 1.0)

func get_health_ui() -> HealthUI: return _health_ui

func _on_upgrade_changed() -> void:
	pass

func get_sell_value() -> float: return get_health_ratio() * TowerInfo.get_tower_cost(_my_type)

func get_foundation() -> TowerFoundation: 
	if _founation_upgrades:
		return _founation_upgrades.get_foundation()
	return null

func _die() -> void:
	#TODO : Explode
	queue_free()
	dead.emit(self)

func get_purchase_manager() -> PurchaseManager: return tower_purchase_manager

static func get_scene_path() -> String: return "Method needs overriting missing"
