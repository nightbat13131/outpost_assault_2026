class_name ClipReloadUI extends Sprite3D

const SHADER_PRIMARY_RATIO = &"primary_ratio"
const SHADER_GHOST_RATIO = &"ghost_ratio"
const SHADER_PRIMARY_COLOR = &"primary_color"

var _reload_info : ReloadInfo: set = set_reload_info

var _primary_ratio := .75: 
	set(value):
		_primary_ratio = value
		_set_shader_parameter(SHADER_PRIMARY_RATIO, _primary_ratio)

var _ghost_ratio := 0.0:
	set(value):
		_ghost_ratio = value
		_set_shader_parameter(SHADER_GHOST_RATIO, _ghost_ratio)

var _suppress := false : set = set_suppressed

func _ready() -> void:
	# TODO set clip ui colors based on utlities/accessabilty settings 
	_ghost_ratio = 0.0
	set_reload_info(_reload_info)

func set_reload_info(info: ReloadInfo) -> void:
	#prints("ClipUI:",self, "old:", _reload_info, "new:",  info)
	_disconect()
	_reload_info = info
	if _reload_info:
		#prints("ClipUI:",self, "_reload_info:", _reload_info)
		_reload_info.changed.connect(_on_reload_change)
		_on_reload_change()
		set_suppressed(false)
	else: 
		set_suppressed(true)

func _on_reload_change() -> void:
	_primary_ratio = _reload_info.get_ratio_clipped_reload()
	#prints(self, bar.ratio)
	_set_shader_parameter(SHADER_PRIMARY_COLOR ,_reload_info.get_ui_color())
	#bar.set_self_modulate(_reload_info.get_ui_color())

func _disconect() -> void:
	if _reload_info:
		if _reload_info.changed.is_connected(_on_reload_change):
			_reload_info.changed.disconnect(_on_reload_change)


func _set_shader_parameter(param: StringName, value: Variant) -> void:
	#print(get_material_override().get_shader_parameter(param))
	#get_material_override().
	set_instance_shader_parameter(param, value)


#func _process(delta: float) -> void:
	#if _ghost_ratio >= _primary_ratio:
		#delta *= GameSpeed.get_delta_mod()
		#_ghost_ratio -= delta

func set_suppressed(_is_suppressed) -> void:
	_suppress = _is_suppressed 
	#suppression_update.emit(_suppress)
	if _suppress:
		hide()
	else:
		show()

func on_die() -> void:
	set_suppressed(true)
