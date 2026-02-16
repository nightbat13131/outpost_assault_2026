@abstract
class_name Tower extends Node2D

signal dead ## I don't think the foundation cares between sold and destroyed.

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

var _max_hp : float
var _hp : float
var _health_ui : HealthUI

#var _foundation : TowerFoundation
var _radar_sensor : RadarSensor
var _founation_upgrades : FoundationUpgrades
@export_flags_2d_physics var _targets : int

func setup(upgrades: FoundationUpgrades, radar_sensor: RadarSensor) -> void:
	_founation_upgrades = upgrades
	_founation_upgrades.upgrade_change.connect(_on_upgrade_changed)
	_radar_sensor = radar_sensor

func _ready() -> void:
	for each_child in get_children():
		if each_child is HealthUI:
			_health_ui = each_child

func damange(damage_delt: float) -> void:
	_hp -= abs(damage_delt)

func _on_upgrade_changed() -> void:
	pass

static func get_display_name(tower_type_: TowerType) -> String: return _type_to_name[tower_type_]

static func get_scene_path() -> String: return "Method needs overriting missing"

static func get_tower_cost(tower_type_: TowerType) -> float: return _type_to_cost[tower_type_]
