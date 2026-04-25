class_name HealthUI extends Sprite3D

const SHADER_PRIMARY_HEALTH = &"primary_ratio"
const SHADER_GHOST_HEALTH = &"ghost_ratio"

@export var _hide_when_full := false
@export var _hide_when_empty := false

var _primary_ratio := .75: 
	set(value):
		_primary_ratio = value
		_set_shader_parameter(SHADER_PRIMARY_HEALTH, _primary_ratio)

var _ghost_ratio := .80:
	set(value):
		_ghost_ratio = value
		_set_shader_parameter(SHADER_GHOST_HEALTH, _ghost_ratio)

var _health_info: HealthInfo : set = set_health_info

var _suppress := false : set = set_suppressed

func _ready() -> void:
	# TODO set health ui colors based on utlities/accessabilty settings 
	set_health_info(_health_info)

func set_health_info(info: HealthInfo) -> void:
	if _health_info:
		_health_info.changed.disconnect(_on_health_changed)
		_health_info.die.disconnect(_on_die)
	_health_info = info
	if _health_info:
		_health_info.changed.connect(_on_health_changed)
		_health_info.die.connect(_on_die)
		_on_health_changed()
		set_suppressed(false)
	else: 
		set_suppressed(true)

func set_health_ratio(value: float, insta_red := false) -> void:
	var is_healing : bool = value > _primary_ratio
	_primary_ratio = clampf(value, 0.0, 1.0)
	if _primary_ratio <= 0 and _hide_when_empty:
		hide()
	elif _primary_ratio >= 1.0 and _hide_when_full: 
		hide()
	else:
		show()
	if is_healing or insta_red: 
		_ghost_ratio = _primary_ratio - 0.01

func _set_shader_parameter(param: StringName, value: Variant) -> void:
	#print(get_material_override().get_shader_parameter(param))
	#get_material_override().
	set_instance_shader_parameter(param, value)


func _get_health_ratio() -> float: return _health_info.ratio

func _process(delta: float) -> void:
	if _ghost_ratio >= _primary_ratio:
		delta *= GameSpeed.get_delta_mod()
		_ghost_ratio -= delta

func set_suppressed(_is_suppressed) -> void:
	_suppress = _is_suppressed 
	#suppression_update.emit(_suppress)
	if _suppress:
		hide()
	else:
		show()

func _on_health_changed() -> void:
	if _health_info:
		set_health_ratio(_health_info.get_health_ratio())
	else:
		push_error(self, "HealthUI failed to disconnect from a change signal")

func _on_die() -> void:
	set_health_info(null)
