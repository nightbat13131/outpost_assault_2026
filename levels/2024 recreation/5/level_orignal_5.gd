@tool
extends Level

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super._ready()
	_trigger_on_wave_complete = _trigger.bind(0)
	_on_wave_complete()

# liniar scripted triggers
func _trigger(number: int) -> void:
	match number:
		0:
			_call_camera_bounds(0)
			await _trigger_dialog_group_index(0)
			_call_wave(0)
			
			_trigger_on_wave_complete = _trigger.bind(1)
		1:
			#_call_camera_bounds(0)
			await _trigger_dialog_group_index(1)
			_call_wave(1)
			_trigger_on_wave_complete = _trigger.bind(2)
		2:
			_call_camera_bounds(1)
			_trigger_dialog_group_index(2)
			_call_wave(2)
			_trigger_on_wave_complete = _trigger.bind(3)
		3:
			#_call_camera_bounds(1)
			await _trigger_dialog_group_index(3)
			_call_wave(3)
			_trigger_on_wave_complete = _trigger.bind(4)
		4:
			#_call_camera_bounds(2)
			await _trigger_dialog_group_index(4)
			_call_wave(4)
			_trigger_on_wave_complete =  _on_victory
