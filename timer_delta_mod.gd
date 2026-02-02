class_name TimerModed extends Node

signal timeout

var _is_running : bool = false
var _wait_time := .05 : set = set_wait_time
var _time_remaining := _wait_time:
	set(value):
		_time_remaining = value
		if _time_remaining <= 0.0:
			timeout.emit()
			_is_running = false
			print(_time_remaining)

func _init(wait_seconds: float = 0.05) -> void:
	set_wait_time(wait_seconds)

func _process(delta: float) -> void:
	if _is_running:
		_time_remaining -= (delta * GameSpeed.get_delta_mod())

func set_wait_time(seconds: float) -> void:
	if seconds < 0.05:
		push_warning(seconds, " TimerModed wait time too low. Setting to 0.05")
		seconds = 0.05
	_wait_time = seconds
	_time_remaining = _wait_time

func start() -> void:
	_is_running = true
