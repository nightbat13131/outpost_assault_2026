class_name RepairUI3D extends Sprite3D

const SHADER_FILL_RATIO = "fill_ratio"

var _primary_ratio := .75: set = set_primary_ratio

func _ready() -> void:
	# TODO set health ui colors based on utlities/accessabilty settings 
	_primary_ratio = 1.0

func set_primary_ratio(value: float) -> void:
	_primary_ratio = value
	_set_shader_parameter(SHADER_FILL_RATIO, _primary_ratio)
	#if _primary_ratio >= 1.0 or _primary_ratio <= 0.0: 
		#hide()
	#else:
		#show()

func _set_shader_parameter(param: StringName, value: Variant) -> void:
	#print(get_material_override().get_shader_parameter(param))
	#get_material_override().
	set_instance_shader_parameter(param, value)
