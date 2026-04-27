@tool
class_name EnemyUnit extends CharacterBody3D
## TODO Does the spawner getting "died" ruin pathing because it frees the node for navigation reference
## - deal with it

signal died(unit: EnemyUnit)

const EVENT_NO_NAV_TARGET = "no nav target"
const EVENT_NAV_TARGET = "has nav target"
const EVENT_DIED = "died"



@export var _enemy_info : EnemyUnitInfo: get = get_enemy_info
@export_category("Sounds")
@export var _sounds_movment : Array[AudioStream]
@export var _sounds_death : Array[AudioStream]

## Keep CanvasItem in this array locked to 0 global rotation
var _g0_rotation : Array[Object] = []
## Have CanvasItem in this array keep their previous global rotation
var _maintain_rotation : Array[CanvasItem] = []

#@export var _rotation_speed_deg_sec := 180
var _sound_player: AudioStreamPlayer3D

var _animated_sprite : AnimatedSprite2D
var _state_machine: StateChart
var _nav_agent : NavigationAgent_Unit
var _nav_target : Node3D :set = set_nav_target
@onready var _ui_anchor: Node3D = %UIAnchor
@onready var _health_ui: HealthUI = %HealthUI

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_detect_children()
	_enemy_info = get_enemy_info().duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	set_collision_mask_value(RadarSensor.COLLISION_GROUND, true)
	set_collision_layer_value(RadarSensor.COLLISION_ENEMY_HUMANS, true)
	get_enemy_info().set_enemy(self)
	_health_ui.set_health_info(get_enemy_info().get_health_info())
	_enemy_info.die.connect(_die)
	_g0_rotation.append(_ui_anchor)

func get_enemy_info() -> EnemyUnitInfo: return _enemy_info

func get_reload_info() -> ReloadInfo: return get_enemy_info().get_reload_info()

func get_kill_reward() -> float: return get_enemy_info().get_kill_reward()

func set_nav_target(node: Node3D) -> void:
	_nav_target = node
	if _nav_agent:
		_nav_agent.set_nav_target(_nav_target)
		return
		if _nav_target:
			send_event(EVENT_NAV_TARGET)
			if _nav_target is NavPoint3D:
				_nav_target.apply_nav_agent(_nav_agent)
			else:
				_nav_agent.set_target_position(_nav_target.global_position)
				#_nav_agent.set_target_desired_distance(DEFAULT_DESIRED_DISTANCE)
		else: 
			send_event(EVENT_NO_NAV_TARGET)

func move(delta_moded: float) -> void:
	## maximum can rotate this frame if needed
	var next_path_pos: Vector2 = Utilities.shift_3d_to_2d(_nav_agent.get_next_path_position())
	#var new_velocity: Vector2 = global_position.direction_to(next_path_pos) * get_max_speed() ## TODO acceloration
	var target_direction = Utilities.shift_3d_to_2d(global_position).direction_to(next_path_pos)
	var rotate_amount = Utilities.delta_radian(rotation.y, target_direction.angle())
	_update_rotation(rotation.y + rotate_amount)
	velocity = Utilities.shift_2d_to_3d(Vector2.from_angle(rotation.y) * get_raw_max_speed() * delta_moded, global_position)
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		velocity.y = velocity.y - (Utilities.get_gravity() * delta_moded)
		
	if not _nav_agent.avoidance_enabled:
		move_and_slide()
	else:
		_nav_agent.set_velocity(velocity)
		pass

func _update_rotation(radian: float) -> void:
	var dict_pre : Dictionary[Object, float]
	for each_maintain in _maintain_rotation:
		dict_pre[each_maintain] = each_maintain.global_rotation
	rotation.y = radian
	for each_lock in _g0_rotation:
		if each_lock:
			each_lock.rotation.y = Utilities.delta_radian(radian, 0)
	for key in dict_pre:
		key.global_rotation.y = dict_pre[key]

func _detect_children() -> void:
	for each_child in get_children():
		if each_child is StateChart:
			_state_machine = each_child
			_state_machine.propagate_call("set_unit", [self])
		elif each_child is NavigationAgent3D:
			_nav_agent = each_child
			_nav_agent.target_reached.connect(_on_target_reached)
			_nav_agent.event.connect(send_event)
		elif each_child is AudioStreamPlayer3D:
			_sound_player = each_child
		elif each_child is AnimatedSprite2D: # TODO: prepair for 3D animation
			_animated_sprite = each_child

func _on_target_reached() -> void:
	if _nav_target is NavPoint3D:
		set_nav_target.call_deferred(_nav_target.get_next_point())

func _get_configuration_warnings() -> PackedStringArray:
	var out : Array[String] ## TODO configuration warnings
	if _enemy_info == null:
		out.append("Enemy Unit needs info resource")
	for each_child in get_children():
		break
	return out

func _die() -> void:
	# death sound
	send_event(EVENT_DIED)
	_ui_anchor.hide()
	set_collision_layer(0) # turn off collision but allow other processing

	_animated_sprite.play(AnimatedSprite2DModded.ANIMATION_DIE)
	await _animated_sprite.animation_finished
	died.emit(self)
	if Engine.is_editor_hint():
		return
	queue_free()

func get_raw_max_speed() -> float:
	if get_enemy_info():
		return get_enemy_info().get_max_speed()
	else: 
		push_warning(self, " has no enemy_info to get speed")
		return 10.0

func send_event(event: String) -> void:
	if _state_machine:
		_state_machine.send_event.call_deferred(event)

func request_animation(animation: String) -> void:
	if _animated_sprite:
		_animated_sprite.play(animation)

func stop_animation(animation: String) -> void:
	if _animated_sprite:
		if _animated_sprite.get_animation() == animation:
			_animated_sprite.stop()

func take_damage(damage_delt : float) -> void: get_enemy_info().take_damage(damage_delt)

func on_outpost_entered(outpost: PlayerOutpost) -> void:
	outpost.take_damage(get_enemy_info().get_outpost_damange())
	## TODO: animation other than die?
	_die()
