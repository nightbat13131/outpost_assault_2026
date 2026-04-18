extends CharacterBody3D

@export var facing_movement := false
@export var _nav_agent: NavigationAgent3D
@export var pivot: Node3D

var _nav_target : NavPoint3D :set = set_nav_target

# Minimum speed of the mob in meters per second.
@export var rand_face : bool = true
@export var min_speed := 10.0
# Maximum speed of the mob in meters per second.
@export var max_speed := 18.0
# The downward acceleration when in the air, in meters per second squared.
#@export var fall_acceleration = 75
#var direction : Vector3
var _state_machine: StateChart

var speed : float
var target_velocity : Vector3

func _ready() -> void:
	#if rand_face:
	#	rotate_y(randf_range(-PI / 4, PI / 4))
	speed = randf_range(min_speed, max_speed)
	if _nav_agent:
		_nav_agent.target_reached.connect(_on_target_reached)
		_nav_agent.navigation_finished.connect(_on_target_reached)

func _physics_process(delta):
	if _nav_agent:
		if facing_movement:
			facing_move(delta)
		else: 
			move(delta)
		return
	target_velocity = (Vector3.FORWARD * speed).rotated(Vector3.UP, rotation.y)
	
	#target_velocity.x = rotation.x * speed
	#target_velocity.z = rotation.z * speed
	#print(is_on_floor())
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (Utilities.get_gravity() * delta)
		
	velocity = target_velocity
	#prints(speed, rotation, velocity)
	move_and_slide()

func _on_target_reached() -> void:
	if _nav_target is NavPoint3D:
		set_nav_target.call_deferred(_nav_target.get_next_point())

func set_nav_target(node: NavPoint3D) -> void:
	_nav_target = node
	if _nav_agent:
		if _nav_target:
			send_event(EnemyUnit.EVENT_NAV_TARGET)
			if _nav_target is NavPoint3D:
				_nav_target.apply_nav_agent(_nav_agent)
			else:
				_nav_agent.set_target_position(_nav_target.global_position)
				_nav_agent.set_target_desired_distance(EnemyUnit.DEFAULT_DESIRED_DISTANCE)
		else: 
			send_event(EnemyUnit.EVENT_NO_NAV_TARGET)

func send_event(event: String) -> void:
	if _state_machine:
		_state_machine.send_event.call_deferred(event)

func move(delta_moded: float) -> void:
	var next_path_pos: Vector3 = _nav_agent.get_next_path_position()
	
	## I only care about the x_z of the next point, gravity covers the y
	next_path_pos.y = global_position.y
	
	
	var target_direction = global_position.direction_to(next_path_pos)
	#direction = target_direction
	#var rotate_amount = Utilities.delta_radian(rotation, target_direction.angle())
	#_update_rotation(rotation + rotate_amount)
	#velocity = Vector2.from_angle(rotation) * get_max_speed()
	
	## TODO acceloration
	velocity = target_direction * speed
	
	# apply gravity to y
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - (5 * delta_moded)
		
	if _nav_agent.avoidance_enabled:
		#_nav_agent.set_velocity(velocity)
		pass
	else:
		move_and_slide()
		#_nav_agent.set_velocity(velocity)

func facing_move(delta_moded: float) -> void:
	
	var next_path_pos: Vector3 = _nav_agent.get_next_path_position()
	
	## I only care about the x_z of the next point, gravity covers the y
	next_path_pos.y = global_position.y
	
	var target_direction : Vector3 = global_position.direction_to(next_path_pos)
	
	#print(next_path_pos, target_direction, Vector2(target_direction.x, target_direction.x).angle()) 
	if pivot.global_position.distance_squared_to(next_path_pos) > .1:
		pivot.look_at(next_path_pos) ## of corse there's a function for it...
	
	## TODO acceloration
	velocity = target_direction * speed
	
	# apply gravity to y
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - (Utilities.get_gravity() * delta_moded)
	move_and_slide()
