class_name Building extends StaticBody2D

signal died
@export var _max_hp : float = 100.0

var _display_info: DisplayHelper
var _health_info : HealthInfo
#var _hp : float: set = _set_health

@onready var _health_ui: HealthUI = %HealthUI
@onready var _clip_reload_ui: ClipReloadUI = %ClipReloadUI
@onready var _button: Button_Trigger_UI = %Button
@onready var _animated_sprite_2d: AnimatedSprite2DModded = %AnimatedSprite2D

func _ready() -> void:
	_health_info = HealthInfo.new()
	_health_info.set_max_health(_max_hp, true)
	_health_info.die.connect(_die)
	_health_ui.set_health_info(_health_info)
	set_collision_layer_value(RadarSensor.COLLISION_ANY_BUILDING, true)
	_setup_display_info()
	if _button:
		_button.selected.connect(_on_selected)

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, _health_info, null, null)

#func get_health_ui() -> HealthUI: return _health_ui

func get_health_info() -> HealthInfo: return _health_info

func get_clip_ui() -> ClipReloadUI: return _clip_reload_ui

func get_display_info() -> DisplayHelper: return _display_info

func take_damage(damage_delt: float) -> void: _health_info.take_damage(damage_delt)

func _on_selected() -> void:
	DisplaySelected.request_display(_display_info)

func _die() -> void:
	died.emit()
	set_collision_layer(0)
	_animated_sprite_2d.play(AnimatedSprite2DModded.ANIMATION_DIE)
	_animated_sprite_2d.animation_finished.connect(_death_animation_complete)
	# TODO explosion

func _death_animation_complete() -> void:
	if Engine.is_editor_hint():
		return
	queue_free()
