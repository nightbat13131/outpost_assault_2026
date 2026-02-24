class_name Level extends Node2D

static var _instance : Level

func _ready() -> void:
	_instance = self
	var base = PlayerMainBase.get_instance()
	if base:
		base.died.connect(_on_base_death)

func _on_base_death() -> void:
	print("PlayerBase died, Game over.")

static func get_instance() -> Level: return _instance
