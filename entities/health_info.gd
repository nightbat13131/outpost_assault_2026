class_name HealthInfo extends Resource

signal die

var _max_hp :  float = 100
var _hp : float = 100: set = _set_health

func _set_health(hp: float) -> void:
	_hp = hp
	changed.emit()
	if _hp <= 0:
		die.emit()

func take_damage(damage_delt: float) -> bool: 
	_hp -= abs(damage_delt)
	return true

func full_heal() -> void: _set_health(_max_hp)

func get_health_ratio() -> float: return clamp(_hp / _max_hp, 0.0, 1.0)

func set_max_health(max_hp: float, force_full:= false) -> void:
	if max_hp <= 0.0: 
		push_error(self, "Max health getting pushed a bad number ", max_hp)
		return
	_max_hp = max_hp
	if force_full:
		_hp = _max_hp
	else:
		_hp = _hp
