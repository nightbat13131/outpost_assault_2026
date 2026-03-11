class_name TowerFoundation extends Sprite2D

const SCENE_PATH = "uid://crf0po16hl0dv"

@export var upgrades : FoundationUpgrades
@export var starting_tower := TowerInfo.TowerType.NA

var _display_info: DisplayHelper: get = get_display_info
var _current_tower: Tower
@onready var _button: Button_Trigger_UI = %Button
@onready var upgrade_manager: UpgradeManager_TowerFoundation = %UpgradeManager

@onready var _tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _health_ui: HealthUI = %HealthUI
@onready var _clip_reload_ui: ClipReloadUI = %ClipReloadUI
@onready var _radar_preview: RadarPreview = %RadarPreview

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_health_ui.set_health_info(null)
	_connect_purchasers()
	if _button:
		_display_info = DisplayHelper.new(self, null, upgrade_manager, null)
		_display_info.unselected.connect(_on_unselected)
		_button.selected.connect(on_selected)
		_button.mouse_entered.connect(_on_hover.bind(true))
		_button.mouse_exited.connect(_on_hover.bind(false))
	add_tower.call_deferred(starting_tower)

func _connect_purchasers() -> void:
	if upgrades == null:
		upgrades = FoundationUpgrades.new()
	else:
		upgrades = upgrades.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) # deep as uses 
		
	_tower_purchase_manager.set_foundation(self)
	upgrades.set_foundation(self)
	upgrade_manager.set_upgrade_info(upgrades)
	upgrade_manager.preview_upgrade.connect(_on_preview_upgrade)
	_radar_preview.set_foundation_upgrades(upgrades)
	for each_child : UpgradeVisualizer in %VisualizeUpgrades.get_children():
		each_child.set_upgrade_info(upgrades)

func add_tower(tower_type: TowerInfo.TowerType) -> void:
	_update_display_info.call_deferred()
	if tower_type != TowerInfo.TowerType.NA:
		_add_tower(tower_type)

func _add_tower(tower_type: TowerInfo.TowerType) -> void:
	if _current_tower != null:
		_current_tower.being_replaced()
	#print("A 1")
	_current_tower = load(TowerInfo.get_tower_filepath(tower_type)).instantiate() as Tower
	#print("A 2 - tower instantiated")
	_current_tower.dead.connect(_on_tower_dead)
	add_child(_current_tower)
	#print("A 3 tower added as child")
	_current_tower.setup(upgrades, _health_ui, _clip_reload_ui)
	#print("A 4 tower setup complete")

func get_display_info() -> DisplayHelper: return _display_info

func on_selected() -> void: 
	DisplaySelected.request_display(get_display_info())
	if _has_tower():
		_current_tower.set_parent_selected(true)

func _on_unselected() -> void:
	if _has_tower():
		_current_tower.set_parent_selected(false)

func _on_hover(is_hover: bool) -> void:
	if _has_tower():
		_current_tower.set_parent_hovered(is_hover)

func _has_tower() -> bool: return _current_tower != null

func _update_display_info() -> void:
	#print("Foundation._update_display_info: ", get_reload_info() )
	_display_info.set_reload_info(get_reload_info())
	_display_info.set_tower(_current_tower)
	if _has_tower():
		_display_info.set_purchaser(_current_tower.get_purchase_manager(), 1)
		_display_info.set_display_name(_current_tower.get_display_name())
	else:
		_display_info.set_purchaser(_tower_purchase_manager, 1)
		_display_info.set_display_name("")
	DisplaySelected.request_refresh.call_deferred(_display_info)

func get_reload_info() -> ReloadInfo_Tower:
	if _current_tower:
		return _current_tower.get_reload_info()
	return null

func get_radar_preview() -> RadarPreview: return _radar_preview

func _on_tower_dead(tower: Tower) -> void:
	if _current_tower == tower:
		_current_tower = null
		_health_ui.set_health_info(null)
		_clip_reload_ui.set_reload_info(null)
	_update_display_info()

func _draw() -> void:
	if Engine.is_editor_hint():
		if starting_tower != TowerInfo.TowerType.NA:
			draw_circle(Vector2.ZERO, 25.0, Color.BROWN, false, 5.0)

func _on_preview_upgrade(upgrade_type: FoundationUpgrades.UpgradeTypes , show_preview: bool) -> void:
	## TODO have upgrades blink when you hover over them
	if upgrade_type == FoundationUpgrades.UpgradeTypes.RADAR:
		if _current_tower and show_preview:
			_radar_preview.set_preview(_current_tower.get_tower_info(), true)
		else:
			_radar_preview.cancle_preview()
