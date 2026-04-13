class_name TowerHolder extends Node

static var _instance : TowerHolder

func _ready() -> void:
	_instance = self

static func get_instance() -> TowerHolder: return _instance
