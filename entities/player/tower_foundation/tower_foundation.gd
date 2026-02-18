class_name TowerFoundation extends Sprite2D

const SCENE_PATH = "uid://crf0po16hl0dv"

var _display_info: DisplayHelper
var _current_tower: Tower
@onready var _button: Button_Trigger_UI = %Button
@onready var radar_sensor: Area2D = %RadarSensor
@onready var upgrade_manager: UpgradeManager_TowerFoundation = %UpgradeManager
@export var upgrades : FoundationUpgrades
@onready var tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _health_ui: HealthUI = %HealthUI

func _ready() -> void:
	_health_ui.set_suppressed(true)
	_connect_purchasers()
	if _button:
		_display_info = DisplayHelper.new(self, _health_ui, upgrade_manager, tower_purchase_manager)
		var size := get_texture().get_size() * .9
		_button.set_size(size)
		_button.set_position(size*-.5)
		_button.selected.connect(on_selected)

func _connect_purchasers() -> void:
	tower_purchase_manager.set_foundation(self)
	if upgrades == null:
		upgrades = FoundationUpgrades.new()
	upgrades = upgrades.duplicate()
	upgrades.set_foundation(self)
	upgrade_manager.set_upgrade_info(upgrades)
	for each_child : UpgradeVisualizer in %VisualizeUpgrades.get_children():
		each_child.set_upgrade_info(upgrades)

func get_display_info() -> DisplayHelper: return _display_info

func on_selected() -> void:
	DisplaySelected.request_display(_display_info)

func add_tower(tower_type: TowerInfo.TowerType) -> void:
	if tower_type == TowerInfo.TowerType.NA:
		print("invalid Tower Type")
		return
	print("Adding a tower of type ", tower_type)
	var _class = TowerInfo.type_to_class[tower_type]
	_current_tower = load(_class.get_scene_path()).instantiate() as Tower
	_current_tower.setup(upgrades, radar_sensor, _health_ui)
	_current_tower.dead.connect(_on_tower_dead)
	_health_ui.set_suppressed(false)
	add_child(_current_tower)
	_display_info.set_purchaser(_current_tower.get_purchase_manager(), 1)
	DisplaySelected.request_refresh.call_deferred(_display_info)

func purge_tower() -> void:
	pass

func _on_tower_dead(tower: Tower) -> void:
	if _current_tower == tower:
		_current_tower = null
	# TODO: if selected, go back to showing the tower builder.

func get_radar() -> RadarSensor: return radar_sensor
