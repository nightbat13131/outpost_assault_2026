@tool
extends Level

func _ready() -> void:
	super._ready()
	_wave_1()

func _wave_1() -> void:
	send_dialog_group(initial_dialog)
	call_wave(1)
