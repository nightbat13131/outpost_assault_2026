class_name GameSpeed extends Control
## TODO:  a pause button that does pause without loosing the last speed instead of 0 button
## would also include a remote pause request.
## x8 and x16 have turned out to be unstable, 
### unit path finding seems to break down - the units get to the end of the navigation path without getting the next point to travel to, 
### changing the speed to a slower number gets them back into pathfinding

signal speed_change(delta_mod: float)

static var _instance : GameSpeed
static var _speed_mod := 1.0
static var _is_paused := false

static func get_delta_mod() -> float: 
	if _is_paused:
		return 0.0
	return _speed_mod

var _1x_button : Button_GameSpeed

func _ready() -> void:
	_instance = self
	tree_exited.connect(_on_tree_exited)
	for each_child in get_children():
		if each_child is Button_GameSpeed:
			each_child.speed_pressed.connect(_on_speed_requested)
			if each_child.multiplier == 1.0:
				_1x_button = each_child
				each_child.remote_press()

func _on_tree_exited() -> void:
	if _instance == self:
		_instance = null
		_speed_mod = 1.0

func _on_speed_requested(multi: float) -> void:
	## Clicking an already active speed returns speet to 1.0
	if _speed_mod == multi:
		if multi != 1.0:
			_1x_button.remote_press()
	else:
		_speed_mod = multi
		speed_change.emit(GameSpeed.get_delta_mod())

static func get_current_speed_manager() -> GameSpeed: return _instance
