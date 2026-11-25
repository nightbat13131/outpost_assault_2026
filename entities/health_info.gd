class_name HealthInfo extends Resource

signal die

var _max_hp :  float = 100
var _hp : float = 100: set = _set_health

func _set_health(hp: float) -> void:
	_hp = clampf(hp , -1.0, _max_hp )
	changed.emit()
	if _hp <= 0:
		die.emit()

func _is_full_health() -> bool: return _hp >= _max_hp

func _is_dead() -> bool: return _hp <= 0.0

func take_damage(damage_delt: float) -> void: _hp -= abs(damage_delt)

func try_heal(heal_amount: float) -> bool: 
	if _is_full_health():
		return false
	if _is_dead():
		return false
	_hp += abs(heal_amount)
	return true

func full_heal() -> void: _set_health(_max_hp)

func get_health_ratio() -> float: return clamp(_hp / _max_hp, 0.0, 1.0)

func set_max_health(max_hp: float, force_full:= false, heal_delta := false) -> void:
	var max_delta := max_hp - _max_hp
	if max_hp <= 0.0: 
		push_error(self, "Max health getting pushed a bad number ", max_hp)
		return
	_max_hp = max_hp
	if force_full:
		_hp = _max_hp
	elif max_delta > 0.0 and heal_delta:
		_hp += max_delta
	else:
		_hp = _hp
