@abstract
class_name Tower extends Node2D

signal dead(tower: Tower) ## I don't think the foundation cares between sold and destroyed.
signal health_changed

enum TowerType {NA = 0, _TEST_UNIT = -10, _TEST_TRUCK = -11}

static var type_to_class :Dictionary = {
	TowerType.NA: Tower,
	TowerType._TEST_UNIT: UnitTower, 
	TowerType._TEST_TRUCK: TruckTower
}

static var _type_to_cost :Dictionary[TowerType, float] = {
	TowerType.NA: 5 ,
	TowerType._TEST_UNIT: 100, 
	TowerType._TEST_TRUCK: 150
}

static var _type_to_name :Dictionary[TowerType, String] = {
	TowerType.NA: " Tower Type not set ",
	TowerType._TEST_UNIT: "Unit", 
	TowerType._TEST_TRUCK: "Truck"
}

static var _type_to_max_hp :Dictionary[TowerType, float] = {
	TowerType.NA: 5.0,
	TowerType._TEST_UNIT: 100.0, 
	TowerType._TEST_TRUCK: 150.0
}

var _my_type := TowerType.NA
var _max_hp : float
var _hp : float: set = set_health
var _health_ui : HealthUI

#var _foundation : TowerFoundation
var _radar_sensor : RadarSensor
var _founation_upgrades : FoundationUpgrades
@export_flags_2d_physics var _targets : int


func _ready() -> void:
	_mid_ready()
	set_max_health(_type_to_max_hp[_my_type])

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

func get_health_ratio() -> float: return clamp(1-(_hp / _max_hp), 0.0, 1.0)

func get_health_ui() -> HealthUI: return _health_ui

func _on_upgrade_changed() -> void:
	pass

func get_sell_value() -> float: return get_health_ratio() * Tower.get_tower_cost(_my_type)

func on_selected() -> void:
	
	pass

func _die() -> void:
	#TODO : Explode
	queue_free()
	dead.emit(self)

static func get_display_name(tower_type_: TowerType) -> String: return _type_to_name[tower_type_]

static func get_scene_path() -> String: return "Method needs overriting missing"

static func get_tower_cost(tower_type_: TowerType) -> float: return _type_to_cost[tower_type_]
