@tool
class_name Level extends Node2D

const WARN_LEVEL_INFO = "Needs Level Info"
const WARN_CAMERA = "Level Needs a CameraBinder"
const WARN_TILEMAP = "How can you have a level without a tilemap?"
const WARN_SPAWN_MANAGER = "Level needs a SpawnManager"
const WARN_TOWER_HOLDER = "Level needs a TowerHolder"
const WARN_PLAYER_OUTPOST = "Level needs a PlayerOutpost"
const WARN_FOUND_BROKEN = "Broken Foundation outside of TowerHolder"
const WARN_FOUND_FOUNDATION = "Foundation outside of TowerHolder"
const WARN_FOUND_SPAWNER = "Spawner outside of SpawnHolder"
const WARN_TILEMAP_DIRECTIONS = "Level needs Tilemap Directions"

static var _instance : Level

@export var _level_info: LevelInfo : get = get_level_info

@export var _dialog_groups: Array[DialogGroup]
@export var _victory_dialog: DialogGroup

var _trigger_on_wave_complete : Callable

var _camera_binder: CameraBinder
var _spawn_manager: SpawnManager

func _init() -> void: _instance = self

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_connect_children()
	get_level_info().on_level_start()
	GameSpeed.on_level_start()
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.CLOSE_ALL) ## handel request reload

func _call_wave(wave_number: int) -> void: _spawn_manager.call_wave(wave_number)

func _call_camera_bounds(index: int) -> void: _camera_binder.trigger_bound_index(index)

## for calling dialog via the standard array
func _trigger_dialog_group_index(index: int) -> bool: 
	var d_group := get_level_info().get_dialog_group(index)# _dialog_groups[index]
	if d_group == null:
		return false
	_send_dialog_group(d_group)
	await  d_group.dialog_complete
	return true

## for calling dialog group that may not be in the standard array
func _send_dialog_group(dialog_group: DialogGroup) -> void: 
	DisplayDialog.set_dialog_group(dialog_group)

func _on_base_death() -> void:
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.LEVEL_LOSS)
	# print("PlayerBase died, Game over.")

func _connect_children() -> void:
	#var tilemap_directions : TileMapLayer_Directions
	#var tower_holder : TowerHolder
	for each_child in get_children():
		if each_child is CameraBinder:
			_camera_binder = each_child
		#elif each_child is TileMapLayer_Directions:
			#tilemap_directions = each_child
		#elif each_child is TowerHolder:
			#tower_holder = each_child
		elif each_child is SpawnManager:
			_spawn_manager = each_child
			_spawn_manager.wave_complete.connect(_on_wave_complete)
		elif (each_child is PlayerOutpost2D):
			if each_child.has_signal('died'):
				each_child.died.connect(_on_base_death)
			else:
				push_error("Missing died signal on ", each_child)
	#if tilemap_directions and _spawn_manager:
		#_spawn_manager.set_tilemap_direction(tilemap_directions)
	#if tilemap_directions and tower_holder:
		#tower_holder.set_tilemap_paths(tilemap_directions)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:Array = [
		WARN_CAMERA,
		WARN_TILEMAP,
		WARN_SPAWN_MANAGER,
		WARN_TOWER_HOLDER,
		WARN_PLAYER_OUTPOST,
		WARN_TILEMAP_DIRECTIONS
	]
	if !_level_info:
		warnings.append(WARN_LEVEL_INFO)
	for each_child in get_children():
		if each_child is CameraBinder:
			warnings.erase(WARN_CAMERA)
		elif each_child is TileMapLogicLayer:
			warnings.erase(WARN_TILEMAP)
		elif each_child is SpawnManager:
			warnings.erase(WARN_SPAWN_MANAGER)
		elif each_child is TowerHolder:
			warnings.erase(WARN_TOWER_HOLDER)
		elif each_child is  PlayerOutpost2D:
			warnings.erase(WARN_PLAYER_OUTPOST)
		elif each_child is TileMapLayer_Directions:
			warnings.erase(WARN_TILEMAP_DIRECTIONS)
			
		elif each_child is BrokenFoundation2D:
			warnings.append(WARN_FOUND_BROKEN)
		elif each_child is TowerFoundation2D:
			warnings.append(WARN_FOUND_FOUNDATION)
		elif each_child is Spawner:
			warnings.append(WARN_FOUND_SPAWNER)
	return warnings

func _on_wave_complete() -> void: 
	if _trigger_on_wave_complete:
		_trigger_on_wave_complete.call()

func get_level_info() -> LevelInfo : 
	if Engine.is_editor_hint():
		return _level_info
	if _level_info == null:
		push_warning(self, " has no level info")
		_level_info = LevelInfo.new()
	return _level_info

func _on_victory() -> void: 
	var victory_dialog = get_level_info()._get_victory_dialog()
	if victory_dialog:
		_send_dialog_group(victory_dialog)
		await victory_dialog.dialog_complete
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.LEVEL_WIN)

static func get_instance() -> Level: return _instance

static func has_instance() -> bool: return _instance != null

static func is_tower_allowed(tower: TowerInfo_reference.TowerType) -> bool:
	if has_instance():
		return get_instance().get_level_info().is_tower_available(tower)
	return false
