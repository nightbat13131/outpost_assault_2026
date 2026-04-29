class_name NavigationAgent_Unit extends NavigationAgent3D

signal event(String)

const DEFAULT_TARGET = Vector3.INF

var _current_index := 0
var _path_array : PackedVector3Array = []
var _last_target_pos : Vector3 = DEFAULT_TARGET

var _nav_target : Node3D

func _ready() -> void:
	target_reached.connect(_on_target_reached)

func set_nav_target(node: Node3D) -> void:
	_nav_target = node
	if _nav_target:
		event.emit(EnemyUnit.EVENT_NAV_TARGET)
		_current_index = 0
		_last_target_pos = DEFAULT_TARGET
		_path_array = []
		#send_event(EVENT_NAV_TARGET)
		if _nav_target is NavPoint3D:
			set_target_position(_nav_target.get_target_location())
			#print(get_current_navigation_result().path)
		else:
			set_target_position(_nav_target.global_position)
			set_target_desired_distance(NavPoint3D.DEFAULT_DESIRED_DISTANCE)
	else: 
		event.emit(EnemyUnit.EVENT_NO_NAV_TARGET)

func get_next_target_pos() -> Vector3:
	var current : Vector3 = get_parent().global_position
	if _path_array.is_empty():
		_path_array = get_current_navigation_result().path
		if _path_array.is_empty():
			return get_next_path_position()
		_last_target_pos = _path_array[_current_index] # likely set to 0 when this is empty
	#var current := Utilities.shift_3d_to_2d(get_parent().global_position)
	if Utilities.distance_squared_2d(current, _last_target_pos) < .1:
		_current_index += 1
		if _current_index >= _path_array.size():
			_on_target_reached() 
			return _last_target_pos
		_last_target_pos = _path_array[_current_index]
	
	
	#print(get_current_navigation_result().path)
	#print(get_current_navigation_path_index())
	return _last_target_pos # get_next_path_position()
	# return Vector3.INF

func _on_target_reached() -> void:
	if _nav_target is NavPoint3D:
		set_nav_target.call_deferred(_nav_target.get_next_point())
	else:
		_nav_target = null
		event.emit(EnemyUnit.EVENT_NO_NAV_TARGET)
