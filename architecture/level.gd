class_name Level extends Node2D

static var _instance : Level

func _ready() -> void:
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
