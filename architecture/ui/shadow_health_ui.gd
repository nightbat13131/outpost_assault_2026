class_name ShadowHealthUI extends HealthUI

var _primary : HealthUI

func _ready() -> void:
	set_suppressed(true)

func set_primary(health_iu: HealthUI) -> void:
	if _primary == health_iu:
		return # no change
	if _primary:
		if _primary.ratio_update.is_connected(_on_ratio_change):
			_primary.ratio_update.disconnect(_on_ratio_change)
		if _primary.suppression_update.is_connected(_on_suppressed_changed):
			_primary.suppression_update.disconnect(_on_suppressed_changed)
	_primary = health_iu
	if _primary == null:
		set_suppressed(true)
		return
	if !_primary.ratio_update.is_connected(_on_ratio_change):
		_primary.ratio_update.connect(_on_ratio_change)
	else: 
		push_error("Managing Signal connections for ShadowHealthUI is failling A")
	if !_primary.suppression_update.is_connected(_on_suppressed_changed):
		_primary.suppression_update.connect(_on_suppressed_changed)
	else: 
		push_error("Managing Signal connections for ShadowHealthUI is failling B")
	set_health_ratio(_primary.get_ratio(), true)
	set_suppressed(_primary._suppress)

func _on_ratio_change(value: float) -> void: set_health_ratio(value)

func _on_suppressed_changed(value: bool) -> void: set_suppressed(value)
