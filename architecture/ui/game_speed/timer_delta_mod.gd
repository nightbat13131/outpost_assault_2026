class_name TimerModded extends Node

signal timeout

var _is_running : bool = false
var _wait_time := .05 : set = set_wait_time
var _is_repeating := false

var _time_remaining := _wait_time : set = _set_time_remaining


func _init(wait_seconds: float = 0.05) -> void:
	set_wait_time(wait_seconds)

func is_running() -> bool: return _is_running

func get_ratio() -> float:
	if _wait_time > 0:
		return clampf(_time_remaining / _wait_time, 0.0, 1.0)
	return 0.0

func _process(delta: float) -> void:
	if _is_running:
		_time_remaining -= (delta * GameSpeed.get_delta_mod())

func set_is_repeating(do_repeat: bool) -> void: _is_repeating = do_repeat

## Set how long the timer runs before signaling Timeout.
func set_wait_time(seconds: float) -> void:
	if seconds < 0.05:
		#push_warning(seconds, " TimerModded wait time too low. Setting to 0.05")
		seconds = 0.05
	_wait_time = seconds
	_time_remaining = _wait_time

func _set_time_remaining(value: float) -> void:
		_time_remaining = value
		if _time_remaining <= 0.0:
			timeout.emit()
			if _is_repeating:
				_time_remaining = (_wait_time - _time_remaining)
			else:
				_is_running = false

func start() -> void:
	# calling deffered fixes a short timer conflict with processing
	_start.call_deferred() # 

func _start() -> void:
	_time_remaining = _wait_time
	_is_running = true
