class_name Building3D extends StaticBody3D

signal died
signal selected
@export var _max_hp : float = 100.0

var _display_info: DisplayHelper
var _health_info : HealthInfo
#var _hp : float: set = _set_health


@onready var health_3d_ui: HealthUI3D = %Health3d_UI
@onready var _clip_reload_ui: ClipReloadUI # =  %ClipReloadUI
@export var action_select : GUIDEAction ## curently nested within the context_camera
# @onready var _button: Button_Trigger_UI = %Button
# @onready var _animated_sprite_2d: AnimatedSprite2DModded = %AnimatedSprite2D

func _ready() -> void:
	_health_info = HealthInfo.new()
	_health_info.set_max_health(_max_hp, true)
	_health_info.die.connect(_die)
	if health_3d_ui:
		health_3d_ui.set_health_info(_health_info)
	set_collision_layer_value(RadarSensor.COLLISION_ANY_BUILDING, true)
	_setup_display_info()
	input_event.connect(_on_input_event)

func _on_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	# only triggered while mouse is overlapping the building. 
	if action_select.is_triggered():
		print(action_select)
		_on_selected()

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, _health_info, null, null)

func get_health_info() -> HealthInfo: return _health_info

func get_clip_ui() -> ClipReloadUI: return _clip_reload_ui

func get_display_info() -> DisplayHelper: return _display_info

func take_damage(damage_delt: float) -> void: _health_info.take_damage(damage_delt)

func _on_selected() -> void: 
	selected.emit()
	DisplaySelected.request_display(_display_info)

func _die() -> void:
	#if _animated_sprite_2d.animation_finished.is_connected(_death_animation_complete):
		# _die already called
	#	return 
	died.emit()
	set_collision_layer(0)
	#_animated_sprite_2d.play(AnimatedSprite2DModded.ANIMATION_DIE)
	#_animated_sprite_2d.animation_finished.connect(_death_animation_complete)
	# TODO explosion

func _death_animation_complete() -> void:
	if Engine.is_editor_hint():
		return
	queue_free()
