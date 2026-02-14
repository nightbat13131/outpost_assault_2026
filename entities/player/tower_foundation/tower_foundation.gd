class_name TowerFoundation extends Sprite2D

const SCENE_PATH = "uid://crf0po16hl0dv"

var _button: Button_Trigger_UI
var _display_info: DisplayHelper
@onready var radar_sensor: Area2D = %RadarSensor
@onready var upgrade_manager: UpgradeManager_TowerFoundation = %UpgradeManager
@export var upgrades : FoundationUpgrades
@onready var gun_nest_purchase_manager: PurchaseManager_GunNest = %GunNestPurchaseManager

func _ready() -> void:
	for each_child in get_children():
		if each_child is Button_Trigger_UI:
			_button = each_child
			_display_info = DisplayHelper.new(self, null)
			var size := get_texture().get_size() * .9
			_button.set_size(size)
			_button.set_position(size*-.5)
			_button.selected.connect(on_selected)
			break
	_connect_upgrade()

func _connect_upgrade() -> void:
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
