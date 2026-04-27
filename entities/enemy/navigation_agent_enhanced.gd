class_name NavigationAgent_Unit extends NavigationAgent3D

signal event(String)


var _nav_target : Node3D

func set_nav_target(node: Node3D) -> void:
	_nav_target = node
	if _nav_target:
		event.emit(EnemyUnit.EVENT_NAV_TARGET)
		#send_event(EVENT_NAV_TARGET)
		if _nav_target is NavPoint3D:
			set_target_position(_nav_target.get_target_location())
			#_nav_target.apply_nav_agent(_nav_agent)
		else:
			set_target_position(_nav_target.global_position)
			set_target_desired_distance(NavPoint3D.DEFAULT_DESIRED_DISTANCE)
	else: 
		event.emit(EnemyUnit.EVENT_NO_NAV_TARGET)

func _process(delta: float) -> void:
	
	
	pass
