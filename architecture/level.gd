@tool
class_name Level extends Node2D

const WARN_CAMERA = "Level Needs a CameraBinder"
const WARN_TILEMAP = "How can you have a level without a tilemap?"
const WARN_SPAWN_MANAGER = "Level needs a SpawnManager"
const WARN_TOWER_HOLDER = "Level needs a TowerHolder"
const WARN_PLAYER_OUTPOST = "Level needs a PlayerOutpost"
const WARN_FOUND_BROKEN = "Broken Foundation outside of TowerHolder"
const WARN_FOUND_FOUNDATION = "Foundation outside of TowerHolder"
const WARN_FOUND_SPAWNER = "Spawner outside of SpawnHolder"

static var _instance : Level

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_instance = self
	var base = PlayerOutpost.get_instance()
	if base:
		base.died.connect(_on_base_death)
	GameSpeed.on_level_start()
	## handel request reload
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.CLOSE_ALL) 

func _on_base_death() -> void:
	LevelPopUps.request_popup(LevelPopUps.PopupTypes.LEVEL_LOSS)
	print("PlayerBase died, Game over.")

static func get_instance() -> Level: return _instance

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:Array = [
		WARN_CAMERA,
		WARN_TILEMAP,
		WARN_SPAWN_MANAGER,
		WARN_TOWER_HOLDER,
		WARN_PLAYER_OUTPOST,
	]
	for each_child in get_children():
		if each_child is CameraBinder:
			warnings.erase(WARN_CAMERA)
		elif each_child is TileMapLayer:
			warnings.erase(WARN_TILEMAP)
		elif each_child is SpawnManager:
			warnings.erase(WARN_SPAWN_MANAGER)
		elif each_child is TowerHolder:
			warnings.erase(WARN_TOWER_HOLDER)
		elif each_child is PlayerOutpost:
			warnings.erase(WARN_PLAYER_OUTPOST)
		elif each_child is BrokenFoundation:
			warnings.append(WARN_FOUND_BROKEN)
		elif each_child is TowerFoundation:
			warnings.append(WARN_FOUND_FOUNDATION)
		elif each_child is Spawner:
			warnings.append(WARN_FOUND_SPAWNER)
		

	return warnings
