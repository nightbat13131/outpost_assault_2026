extends SpinBox

@export var _camera_binder: CameraBinder

var _max_index : int

func _ready() -> void:
	value_changed.connect(_on_value_changed)
	if _camera_binder:
		_max_index = _camera_binder.bounds.size() -1
	else:
		push_warning("CameraBinder Tester missing the CameraBinder")

func _on_value_changed(index) -> void:
	if index > _max_index:
		set_value_no_signal(index)
	elif index < 0:
		set_value_no_signal(0)
	else: 
		_camera_binder.trigger_bound_index(index)
