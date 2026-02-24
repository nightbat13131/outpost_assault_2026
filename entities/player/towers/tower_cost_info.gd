class_name CostButtonInfo_Tower extends CostButtonInfo

@export var tower_type: TowerInfo.TowerType
var _radar_preview : RadarPreview

func get_cost() -> float: return TowerInfo.get_tower_cost(tower_type)

func get_label() -> String: return TowerInfo.get_display_name(tower_type)

func get_tooltip() -> String: return super.get_tooltip()

func set_radar_preview(radar: RadarPreview) -> void: _radar_preview = radar

func on_mouse_entered() -> void:
	if _radar_preview:
		_radar_preview.set_preview(RadarSensor.TargetShape.CIRCLE_FILLED,
		{RadarPreview.OUTER_RADIUS: 300.0}
		)
	# .preview_radar_range_tower(tower_type)

func on_mouse_exited() -> void:
	if _radar_preview:
		_radar_preview.cancle_preview()
	#if _radar_sensor:
	#	_radar_sensor.preview_radar_range_tower()
