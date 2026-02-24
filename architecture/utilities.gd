class_name Utilties extends GDScript

const COLOR_RADAR_PREVIEW = Color.BLACK
const COLOR_RADAR_FILL = Color.DARK_ORCHID


static func delta_radian(source_radian: float, target_radian: float) -> float:
	var _delta_radian : float = target_radian - source_radian
	if abs(_delta_radian) > PI:
		if _delta_radian > PI: 
			_delta_radian -= TAU
		else:
			_delta_radian += TAU
	return _delta_radian
