class_name LevelInfo extends Resource

@export var level_name: String
@export var level_uid: String
@export var starting_gold: float = 1000

func get_level_name() -> String:
	if level_name:
		return level_name
	return "Nameless Level"

func get_level_path() -> String: return level_uid

func on_level_start() -> void: 
	GoldManager.on_level_start(starting_gold)
