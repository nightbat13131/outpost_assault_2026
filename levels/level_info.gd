class_name LevelInfo extends Resource

@export var level_name: String
@export var level_uid: String

func get_level_name() -> String:
	if level_name:
		return level_name
	return "Nameless Level"

func get_level_path() -> String: return level_uid
