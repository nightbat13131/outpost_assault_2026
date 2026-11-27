class_name TowerFoundation extends Foundation

const SCENE_PATH = "uid://crf0po16hl0dv"
const SCENE_PATH_OG = "uid://cpfajst60unk2"
const FACING_RADIAN_SNAP = TAU/16

@export var upgrades : FoundationUpgrades
@export var starting_tower := TowerInfo.TowerType.NA

var _current_tower: Tower


@onready var upgrade_manager: UpgradeManager_TowerFoundation = %UpgradeManager
@onready var visualize_upgrades: UpgradeVisualizer = %VisualizeUpgrades

@onready var _tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _health_ui: HealthUI = %HealthUI
@onready var _clip_reload_ui: ClipReloadUI = %ClipReloadUI
@onready var _radar_preview: RadarPreview = %RadarPreview : get = get_radar_preview

var _facing_radian := 0.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super._ready()
	_health_ui.set_health_info(null)
	_select_button.mouse_entered.connect(_on_hover.bind(true))
	_select_button.mouse_exited.connect(_on_hover.bind(false))

func _post_ready() -> void:
	set_facing_radian(TileMapLayer_Directions.get_facing_direction(global_position) )
	queue_redraw()
	_connect_purchasers()
	add_tower(starting_tower)

func get_display_info() -> DisplayHelper: 
	if _display_info == null:
		_display_info = DisplayHelper.new(self, null, upgrade_manager, null)
		_display_info.unselected.connect(_on_selection_cancled)
	return _display_info

#func uses_facing_radian() -> bool: return true

func get_facing_radian() -> float: return _facing_radian

func set_facing_radian(value: float) -> void:
	## value = value % (TAU/4) ## fmod(value, TAU/4)
	value = snappedf(value, FACING_RADIAN_SNAP)
	
	_facing_radian = value
	queue_redraw()
	if _has_tower():
		_current_tower.configure_default_rotation(_facing_radian, true, false, false)

func _connect_purchasers() -> void:
	if upgrades == null:
		upgrades = FoundationUpgrades.new()
	else:
		upgrades = upgrades.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) # deep as uses 
	_tower_purchase_manager.set_foundation(self)
	upgrades.set_foundation(self)
	upgrade_manager.set_upgrade_info(upgrades)
	upgrade_manager.preview_upgrade.connect(_on_preview_upgrade)
	get_radar_preview().set_foundation_upgrades(upgrades)
	visualize_upgrades.set_upgrade_info(upgrades)

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
	_current_tower.setup(upgrades, _health_ui, _clip_reload_ui, _facing_radian)
	#print("A 4 tower setup complete")
	get_radar_preview().cancle_preview()
	_current_tower.set_parent_selected(_is_selected)

func on_selected() -> void: _set_is_selected(true)

#func _on_unselected() -> void: set_is_selected(false)

func _set_is_selected(is_selected: bool) -> void:
	super._set_is_selected(is_selected)
	if _has_tower():
		_current_tower.set_parent_selected(_is_selected)

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
	draw_line(Vector2.ZERO, Vector2.from_angle(_facing_radian)*100, Color.BLACK, 10 )
	if Engine.is_editor_hint():
		if starting_tower != TowerInfo.TowerType.NA:
			draw_circle(Vector2.ZERO, 25.0, Color.BROWN, false, 5.0)

func _on_preview_upgrade(upgrade_type: FoundationUpgrades.UpgradeTypes , show_preview: bool) -> void:
	## TODO have upgrades blink when you hover over them
	if upgrade_type == FoundationUpgrades.UpgradeTypes.RADAR:
		if _current_tower and show_preview:
			get_radar_preview().set_preview(_current_tower.get_tower_info(), true)
		else:
			get_radar_preview().cancle_preview()

static func get_packed_scene_path(foundation_type: FoundationType) -> String:
	if foundation_type == FoundationType.OG:
		return SCENE_PATH_OG
	return SCENE_PATH
