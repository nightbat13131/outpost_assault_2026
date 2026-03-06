@tool
extends Level

@export var _hint_dialog: DialogGroup

func _ready() -> void:
	super._ready()
	_trigger(0)

# liniar scripted triggers
func _trigger(number: int) -> void:
	match number:
		0:
			trigger_dialog_group_index(0)
			call_wave(0)
			call_camera_bounds(0)
			_next_trigger = _trigger.bind(1)
		1:
			trigger_dialog_group_index(1)
			call_wave(1)
			#call_camera_bounds(0)
			_next_trigger = _trigger.bind(2)
		2:
			trigger_dialog_group_index(2)
			call_wave(2)
			#call_camera_bounds(1)
			_next_trigger = _trigger.bind(3)
		3:
			trigger_dialog_group_index(3)
			call_wave(3)
			call_camera_bounds(1)
			_next_trigger = _trigger.bind(4)
		4:
			#trigger_dialog_group_index(3)
			call_wave(3)
			call_camera_bounds(2)
			_next_trigger = _on_victory

func _hint_trigger() -> void:
	send_dialog_group(_hint_dialog)
