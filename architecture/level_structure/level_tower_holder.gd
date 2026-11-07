class_name TowerHolder extends Node

static var _instance : TowerHolder
var _tilemap_paths : TileMapLayer_Directions : set = set_tilemap_paths

func _ready() -> void:
	_instance = self

func set_tilemap_paths(paths: TileMapLayer_Directions) -> void:
	_tilemap_paths = paths
 
static func get_instance() -> TowerHolder: return _instance
