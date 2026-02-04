@tool
class_name EnemyUnit extends CharacterBody2D
## TODO Does the spawner getting "died" ruin pathing because it frees the node for navigation reference
## - deal with it

signal died(unit: EnemyUnit)

const EVENT_NO_NAV_TARGET = "no nav target"
const EVENT_DIED = "died"

const DEFAULT_DESIRED_DISTANCE := 25.0

@export var _enemy_info : EnemyUnitInfo
@export_category("Sounds")
@export var _sounds_movment : Array[AudioStream]
@export var _sounds_death : Array[AudioStream]
var _sound_player: AudioStreamPlayer2D

var _animated_sprite : AnimatedSprite2D
var _state_machine: StateChart
var _nav_agent : NavigationAgent2D
var _nav_target : Node2D :set = set_nav_target
var _health_ui: HealthUI

var _health : float = 100.0 : set = _set_health

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_detect_children()
	_set_health(_enemy_info.get_max_health())

func set_nav_target(node: Node2D) -> void:
	_nav_target = node
	if _nav_agent:
		if _nav_target:
			if _nav_target is NavPoint:
				_nav_target.apply_nav_agent(_nav_agent)
			else:
				_nav_agent.set_target_position(_nav_target.global_position)
				_nav_agent.set_target_desired_distance(DEFAULT_DESIRED_DISTANCE)
		else: 
			send_event(EVENT_NO_NAV_TARGET)

func move(_delta_moded: float) -> void:
	var next_path_pos: Vector2 = _nav_agent.get_next_path_position()
	var cur_agent_pos: Vector2 = global_position
	var new_velocity: Vector2 = cur_agent_pos.direction_to(next_path_pos) * get_max_speed() ## TODO acceloration
	if not _nav_agent.avoidance_enabled:
		velocity = new_velocity
		move_and_slide()
	else:
		_nav_agent.set_velocity(new_velocity)

func _detect_children() -> void:
	for each_child in get_children():
		if each_child is StateChart:
			_state_machine = each_child
			_state_machine.propagate_call("set_unit", [self])
		elif each_child is NavigationAgent2D:
			_nav_agent = each_child
			_nav_agent.target_reached.connect(_on_target_reached)
		elif each_child is AudioStreamPlayer2D:
			_sound_player = each_child
		elif each_child is AnimatedSprite2D:
			_animated_sprite = each_child
		elif each_child is HealthUI:
			_health_ui = each_child
			_health_ui.set_health_ratio(1.0)

func _on_target_reached() -> void:
	if _nav_target is NavPoint:
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
	set_collision_layer(0) # turn off collision
	_animated_sprite.play(AnimatedSprite2DModded.ANIMATION_DIE)
	await _animated_sprite.animation_finished
	died.emit(self)
	if Engine.is_editor_hint():
		return
	queue_free()

func get_max_speed() -> float:
	if _enemy_info:
		return _enemy_info.get_max_speed() * GameSpeed.get_delta_mod()
	else: 
		push_warning(self, " has no enemy_info to get speed")
		return 10.0

func get_max_health() -> float:
	if _enemy_info:
		return _enemy_info.get_max_health()
	else: 
		push_warning(self, " has no enemy_info to get health")
		return 100.0

func send_event(event: String) -> void:
	print(event)
	if _state_machine:
		_state_machine.send_event(event)

func request_animation(animation: String) -> void:
	if _animated_sprite:
		_animated_sprite.play(animation)

func stop_animation(animation: String) -> void:
	if _animated_sprite:
		if _animated_sprite.get_animation() == animation:
			_animated_sprite.stop()

func _set_health(value : float) -> void:
	_health = value
	if _health_ui:
		_health_ui.set_health_ratio(_health / get_max_health())
	if _health <= 0.0:
		_die()

func take_damage(value : float) -> void: _health -= value
