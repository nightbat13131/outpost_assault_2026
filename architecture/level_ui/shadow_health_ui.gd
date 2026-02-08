class_name ShadowHealthUI extends HealthUI

var _primary : HealthUI

func set_primary(health_iu: HealthUI) -> void:
	if _primary == health_iu:
		return # no change
	if _primary:
		if _primary.ratio_update.is_connected(_on_ratio_change):
			_primary.ratio_update.disconnect(_on_ratio_change)
	_primary = health_iu
	if !_primary.ratio_update.is_connected(_on_ratio_change):
		_primary.ratio_update.connect(_on_ratio_change)
	else: 
		push_error("Managing Signal connections for ShadowHealthUI is failling")
	set_health_ratio(_primary.get_ratio(), true)

func _on_ratio_change(value: float) -> void:
	set_health_ratio(value)
