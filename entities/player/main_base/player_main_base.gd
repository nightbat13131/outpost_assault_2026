class_name PlayerMainBase extends Area2D

signal died

static var _instatnce : PlayerMainBase

@onready var _health_ui: HealthUI = %HealthUI
var _max_hp : float
var _hp : float: set = _set_health

func _ready() -> void:
	set_max_health(100.0, true)
	_instatnce = self

func set_max_health(max_hp: float, force_full:= false) -> void:
	if max_hp <= 0.0: 
		push_error(self, "Max health getting pushed a bad number ", max_hp)
		return
	_max_hp = max_hp
	if force_full:
		_hp = _max_hp
	else:
		_hp = _hp

func _set_health(hp: float) -> void:
	_hp = hp
	if _health_ui:
		_health_ui.set_health_ratio(_get_health_ratio())
	if _hp <= 0:
		_die()

func _get_health_ratio() -> float: return clamp(_hp / _max_hp, 0.0, 1.0)

func get_health_ui() -> HealthUI: return _health_ui

func take_damage(damage_delt: float) -> void: _hp -= abs(damage_delt)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 100.0, Color.CADET_BLUE)

func _die() -> void:
	# TODO explosion
	died.emit() 
	if _instatnce == self:
		_instatnce = null
	queue_free()

static func get_instance() -> PlayerMainBase: return _instatnce
