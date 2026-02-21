class_name CostButtonInfo_Tower extends CostButtonInfo

@export var tower_type: TowerInfo.TowerType
var _radar_sensor : RadarSensor

func get_cost() -> float: return TowerInfo.get_tower_cost(tower_type)

func get_label() -> String: return TowerInfo.get_display_name(tower_type)

func get_tooltip() -> String: return super.get_tooltip()

func set_radar(radar_sensor: RadarSensor) -> void: _radar_sensor = radar_sensor

func on_mouse_entered() -> void:
	_radar_sensor.preview_radar_range(tower_type)

func on_mouse_exited() -> void:
	if _radar_sensor:
		_radar_sensor.preview_radar_range()
