class_name TowerFoundation extends Sprite2D

const SCENE_PATH = "uid://crf0po16hl0dv"

@export var upgrades : FoundationUpgrades
@export var starting_tower := TowerInfo.TowerType.NA

var _display_info: DisplayHelper
var _current_tower: Tower
@onready var _button: Button_Trigger_UI = %Button
#@onready var _radar_sensor: RadarSensor = %RadarSensor
@onready var upgrade_manager: UpgradeManager_TowerFoundation = %UpgradeManager



@onready var _tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _health_ui: HealthUI = %HealthUI
@onready var _clip_reload_ui: ClipReloadUI = %ClipReloadUI
@onready var _radar_preview: RadarPreview = %RadarPreview

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_health_ui.set_suppressed(true)
	_connect_purchasers()
	if _button:
		_display_info = DisplayHelper.new(self, null, upgrade_manager, null)
		var size := get_texture().get_size() * .9
		_button.set_size(size)
		_button.set_position(size*-.5)
		_button.selected.connect(on_selected)
	add_tower(starting_tower)

func _draw() -> void:
	if Engine.is_editor_hint():
		if starting_tower != TowerInfo.TowerType.NA:
			draw_circle(Vector2.ZERO, 25.0, Color.BROWN, false, 5.0)

func _connect_purchasers() -> void:
	_tower_purchase_manager.set_foundation(self)
	if upgrades == null:
		upgrades = FoundationUpgrades.new()
	upgrades = upgrades.duplicate(true) # testing showed this needed to be deep
	upgrades.set_foundation(self)
	upgrade_manager.set_upgrade_info(upgrades)
	for each_child : UpgradeVisualizer in %VisualizeUpgrades.get_children():
		each_child.set_upgrade_info(upgrades)
	_update_display_info.call_deferred()

func get_display_info() -> DisplayHelper: return _display_info

func on_selected() -> void: DisplaySelected.request_display(_display_info)

func _has_tower() -> bool: return _current_tower != null

func _update_display_info() -> void:
	if _has_tower():
		_display_info.set_purchaser(_current_tower.get_purchase_manager(), 1)
		_display_info.set_display_name(_current_tower.get_display_name())
		if _current_tower.has_shooter():
			_display_info.set_reload_info(_current_tower.get_reload_info())
		else:
			_display_info.set_reload_info(null)
	else:
		_display_info.set_purchaser(_tower_purchase_manager, 1)
		_display_info.set_reload_info(null)
		_display_info.set_display_name("")
	_display_info.set_tower(_current_tower)
	DisplaySelected.request_refresh.call_deferred(_display_info)

func add_tower(tower_type: TowerInfo.TowerType) -> void:
	if tower_type != TowerInfo.TowerType.NA:
		_add_tower(tower_type)

func _add_tower(tower_type: TowerInfo.TowerType) -> void:
	#var _class = TowerInfo.type_to_class[tower_type]
	if _current_tower != null:
		_current_tower.being_replaced()
	_current_tower = load(TowerInfo.get_tower_filepath(tower_type)).instantiate() as Tower
	_current_tower.setup(upgrades, _health_ui, _clip_reload_ui) # can't call defered because of other timing
	_current_tower.dead.connect(_on_tower_dead)
	_health_ui.set_suppressed(false)
	add_child(_current_tower)
	_update_display_info()

func get_radar_preview() -> RadarPreview: return _radar_preview

func _on_tower_dead(tower: Tower) -> void:
	if _current_tower == tower:
		_current_tower = null
		_health_ui.set_health_info(null)
		_clip_reload_ui.set_reload_info(null)
	_update_display_info()
