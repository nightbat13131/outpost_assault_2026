class_name Building extends StaticBody3D

signal died
signal selected
#@export var _max_hp : float = 100.0

var _display_info: DisplayHelper: get = get_display_info
#var _health_info : HealthInfo: get = get_health_info,  set = set_health_info

@export var _health_ui: HealthUI: get = get_health_ui
@export var _clip_ui: ClipReloadUI: get = get_clip_ui
@onready var mouse_interaction_node: MouseInteractionNode = %MouseInteractionNode

func _ready() -> void:
	if mouse_interaction_node:
		mouse_interaction_node.selected.connect(_on_selected)
		mouse_interaction_node.mouse_in.connect(_on_hover)
	#if get_health_ui():
		#if _max_hp > 0:
			#set_health_info(HealthInfo.new())
			#_health_info.set_max_health(_max_hp, true)
			#_health_info.die.connect(_die)
			#get_health_ui().set_health_info(_health_info)
	set_collision_layer_value(RadarSensor.COLLISION_ANY_BUILDING, true)
	_setup_display_info()
	if _display_info: # some buildings overwrite to have no display info
		_display_info.unselected.connect(_on_selection_cancled)

func set_health_info(health_info: HealthInfo) -> void:
	if get_health_ui():
		get_health_ui().set_health_info(health_info)
	else: 
		push_warning(self, " Building has no health_ui")

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, null, null, null, "Default Building")

func get_health_info() -> HealthInfo: 
	if get_health_ui():
		return get_health_ui().get_health_info()
	return null

func get_clip_ui() -> ClipReloadUI: return _clip_ui

func get_health_ui() -> HealthUI: return _health_ui

func get_display_info() -> DisplayHelper: return _display_info

func take_damage(damage_delt: float) -> bool: 
	if get_health_info():
		get_health_info().take_damage(damage_delt)
		return true
	return false

func _on_selected() -> void: 
	selected.emit()
	DisplaySelected.request_display(get_display_info())

func _on_selection_cancled() -> void: pass

func _on_hover(is_hover: bool) -> void: pass

func _die() -> void:
	#if _animated_sprite_2d.animation_finished.is_connected(_death_animation_complete):
		# _die already called
	#	return 
	died.emit()
	set_collision_layer(0)
	#_animated_sprite_2d.play(AnimatedSprite2DModded.ANIMATION_DIE)
	#_animated_sprite_2d.animation_finished.connect(_death_animation_complete)
	# TODO explosion
	_death_animation_complete()

func _death_animation_complete() -> void:
	if Engine.is_editor_hint():
		return
	queue_free()
