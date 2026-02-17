class_name RadarSensor extends Area2D

const RADAR_FADE := .25

var _radar_preview: float = 0.0

var _targets : Array =[]

func has_target() -> bool: return !_targets.is_empty()

func set_target_types(target_collition_mask: int) -> void:
	set_collision_mask(target_collition_mask)
	#TODO: recalculate targets in current area

func set_target_logic() -> void:
	
	pass

func get_target() -> void:
	pass

func preview_radar_range(radius: float) -> void: 
	_radar_preview = radius
	queue_redraw()

func _draw() -> void:
	if _radar_preview >= 5.0:
		draw_circle(
			Vector2.ZERO, 
			_radar_preview, 
			Color(Utilties.COLOR_RADAR_PREVIEW, RADAR_FADE)
		)
