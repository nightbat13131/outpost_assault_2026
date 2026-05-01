@tool
class_name Level extends Node

const WARN_LEVEL_INFO = "Needs Level Info"
const WARN_CAMERA = "Level Needs a CameraBinder"
const WARN_TILEMAP = "How can you have a level without a tilemap?"
const WARN_SPAWN_MANAGER = "Level needs a SpawnManager"
const WARN_TOWER_HOLDER = "Level needs a TowerHolder"
const WARN_PLAYER_OUTPOST = "Level needs a PlayerOutpost"
const WARN_FOUND_BROKEN = "Broken Foundation outside of TowerHolder"
const WARN_FOUND_FOUNDATION = "Foundation outside of TowerHolder"
const WARN_FOUND_SPAWNER = "Spawner outside of SpawnHolder"

static var _instance : Level

@export var _level_info: LevelInfo

@export var _dialog_groups: Array[DialogGroup]

var _trigger_on_wave_complete : Callable

var _camera_binder: CameraBinder
var _spawn_manager: SpawnManager

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_instance = self
	_conect_children()
	_level_info.on_level_start()
	GameSpeed.on_level_start()
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.CLOSE_ALL) ## handel request reload

func _process(delta: float) -> void:
	var __size = 100
	var __v_size = Vector3(__size*.5, 1, __size*.5)
	DebugDraw3D.draw_grid(Vector3(0,-1,0), Vector3(__size,0,0), Vector3(0,0,__size), Vector2i(__size,__size), Color.DARK_GRAY, true)
	
	DebugDraw3D.draw_line(Vector3.RIGHT*__size, Vector3.LEFT*__size)
	DebugDraw3D.draw_line(Vector3.FORWARD*__size, Vector3.BACK*__size)
	#DebugDraw3D.draw_grid(Vector3.ZERO, Vector3.ONE, Vector3.ONE, Vector2i.ONE )

func call_wave(wave_number: int) -> void: _spawn_manager.call_wave(wave_number)

func call_camera_bounds(index: int) -> void: _camera_binder.trigger_bound_index(index)

## for calling dialog via the standard array
func trigger_dialog_group_index(index: int) -> void: 
	if index >= _dialog_groups.size():
		push_warning(self, "send_dialog_group index out of bounds. index: ", index, " size: ", _dialog_groups.size())
	else: 
		send_dialog_group(_dialog_groups[index])

## for calling dialog group that may not be in the standard array
func send_dialog_group(dialog_group: DialogGroup) -> void: 
	DisplayDialog.set_dialog_group(dialog_group)

func _on_base_death() -> void:
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.LEVEL_LOSS)
	print("PlayerBase died, Game over.")

func _conect_children() -> void:
	for each_child in get_children():
		if each_child is CameraBinder:
			_camera_binder = each_child
		elif each_child is SpawnManager:
			_spawn_manager = each_child
			_spawn_manager.wave_complete.connect(_on_wave_complete)
		elif each_child is PlayerOutpost:
			each_child.died.connect(_on_base_death)

		#elif each_child is TowerHolder:
		#elif each_child is TileMapLayer:

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:Array = [
		WARN_CAMERA,
		WARN_TILEMAP,
		WARN_SPAWN_MANAGER,
		WARN_TOWER_HOLDER,
		WARN_PLAYER_OUTPOST,
	]
	if !_level_info:
		warnings.append(WARN_LEVEL_INFO)
	for each_child in get_children():
		if each_child is CameraBinder:
			warnings.erase(WARN_CAMERA)
		elif each_child is TileMapLayer:
			warnings.erase(WARN_TILEMAP)
		elif each_child is SpawnManager:
			warnings.erase(WARN_SPAWN_MANAGER)
		elif each_child is TowerHolder:
			warnings.erase(WARN_TOWER_HOLDER)
		elif each_child is  PlayerOutpost:
			warnings.erase(WARN_PLAYER_OUTPOST)

		elif each_child is BrokenFoundation:
			warnings.append(WARN_FOUND_BROKEN)
		elif each_child is TowerFoundation:
			warnings.append(WARN_FOUND_FOUNDATION)
		elif each_child is Spawner:
			warnings.append(WARN_FOUND_SPAWNER)
	return warnings

func _on_wave_complete() -> void: 
	if _trigger_on_wave_complete:
		_trigger_on_wave_complete.call()

func get_level_info() -> LevelInfo : return _level_info

func _on_victory() -> void: LevelPopUps.request_popup(LevelPopUps.PopupTypes.LEVEL_WIN)

static func get_instance() -> Level: return _instance
