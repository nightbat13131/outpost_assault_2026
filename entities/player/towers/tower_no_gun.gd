class_name TowerNoGun extends Tower

static func get_scene_path() -> String: return "uid://n0l8egj3gjg6"

func _mid_ready() -> void: _my_type = TowerInfo.TowerType._NoShooter
