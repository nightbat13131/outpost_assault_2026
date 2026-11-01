@tool
class_name NavigationLeg extends Resource

var _start_global_position := Vector2.ZERO
var _start_direction := Utilities.DIRECTION_INIT
var _stop_global_position := Vector2.ONE
var _travel_direction : int

func get_target_global_position() -> Vector2: return _stop_global_position

func set_start(global_position := Vector2.ZERO, start_direction := Utilities.DIRECTION_STOP) -> void:
	_start_global_position = global_position
	_start_direction = start_direction

func get_start_global_position() -> Vector2: return _start_global_position

func get_start_direction() -> int: return _start_direction

func set_destination(global_position := Vector2.ONE, travel_direction := Utilities.DIRECTION_STOP) -> void:
	_stop_global_position = global_position
	_travel_direction = travel_direction

func get_direction() -> int: return _travel_direction
