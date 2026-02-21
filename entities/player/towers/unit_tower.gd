class_name UnitTower extends Tower

static func get_scene_path() -> String: return "uid://dro1735nlrdor"

func _mid_ready() -> void:
	_my_type = TowerInfo.TowerType._TEST_UNIT
