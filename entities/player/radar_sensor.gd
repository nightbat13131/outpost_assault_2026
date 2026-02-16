class_name RadarSensor extends Area2D


var _targets : Array =[]

func has_target() -> bool: return !_targets.is_empty()

func set_target_types() -> void:
	# clear all other types and only use what is in this setter
	
	pass

func set_target_logic() -> void:
	
	pass

func get_target() -> void:
	pass
