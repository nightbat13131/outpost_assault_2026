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
			trigger_dialog_group_index(0)
			call_wave(0)
			call_camera_bounds(0)
			_trigger_on_wave_complete = _trigger.bind(1)
		1:
			trigger_dialog_group_index(1)
			call_wave(1)
			call_camera_bounds(1)
			_trigger_on_wave_complete = _trigger.bind(2)
		2:
			trigger_dialog_group_index(2)
			call_wave(2)
			#call_camera_bounds(1)
			_trigger_on_wave_complete = _on_victory



#
#func _triggerW(): # last wave
	#var call_args = [TalkingHead.TALKER.BLACK, "Duh duh duh duh... Oh, wait, wrong game. Sorry. Yay, we won!", false]
	#dialog_box.start_event(call_args[0], call_args[1], call_args[2])
	#_on_enemies_defeated() 
