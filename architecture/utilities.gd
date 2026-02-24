class_name Utilties extends GDScript

const COLOR_RADAR_PREVIEW = Color.BLACK
const COLOR_RADAR_FILL = Color.DARK_ORCHID


static func delta_radian(source_radian: float, target_radian: float) -> float:
	var delta_radian : float = target_radian - source_radian
	#prints("0",rotation, target_angle, delta_radian)
	prints(delta_radian, PI, abs(delta_radian))
	if abs(delta_radian) > PI:
		if delta_radian > PI: 
			delta_radian -= TAU
		else:
			delta_radian += TAU
	return delta_radian
