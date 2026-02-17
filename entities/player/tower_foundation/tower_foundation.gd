class_name TowerFoundation extends Sprite2D

const SCENE_PATH = "uid://crf0po16hl0dv"

var _button: Button_Trigger_UI
var _display_info: DisplayHelper
var _current_tower: Tower
@onready var radar_sensor: Area2D = %RadarSensor
@onready var upgrade_manager: UpgradeManager_TowerFoundation = %UpgradeManager
@export var upgrades : FoundationUpgrades
@onready var tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _health_ui: HealthUI = %HealthUI

func _ready() -> void:
	_health_ui.set_suppressed(true)
	for each_child in get_children():
		if each_child is Button_Trigger_UI:
			_button = each_child
			_display_info = DisplayHelper.new(self, _health_ui)
			var size := get_texture().get_size() * .9
			_button.set_size(size)
			_button.set_position(size*-.5)
			_button.selected.connect(on_selected)
			break
	_connect_purchasers()

func _connect_purchasers() -> void:
	tower_purchase_manager.set_foundation(self)
	if upgrades == null:
		upgrades = FoundationUpgrades.new()
	upgrades = upgrades.duplicate()
	upgrades.set_foundation(self)
	#upgrades.upgrade_change.connect(_on_upgrade_change)
	upgrade_manager.set_upgrade_info(upgrades)
	for each_child : UpgradeVisualizer in %VisualizeUpgrades.get_children():
		each_child.set_upgrade_info(upgrades)

func get_display_info() -> DisplayHelper: return _display_info

func on_selected() -> void:
	DisplaySelected.request_display(_display_info)
	upgrade_manager.on_select()
	if _current_tower:
		tower_purchase_manager.hide_section()
		_current_tower.on_selected()
	else: 
		tower_purchase_manager.on_select()

func add_tower(tower_type: Tower.TowerType) -> void:
	print("Adding a tower of type ", tower_type)
	var _class = Tower.type_to_class[tower_type]
	_current_tower = load(_class.get_scene_path()).instantiate()
	if _current_tower is Tower: # cast
		_current_tower.setup(upgrades, radar_sensor, _health_ui)
		_current_tower.dead.connect(_on_tower_dead)
		_health_ui.set_suppressed(false)
	elif _current_tower == null:
		_health_ui.set_suppressed(true)
	add_child(_current_tower)
	tower_purchase_manager.hide_section()


func _on_tower_dead(tower: Tower) -> void:
	if _current_tower == tower:
		_current_tower = null
	# TODO: if selected, go back to showing the tower builder.

func get_radar() -> RadarSensor: return radar_sensor
