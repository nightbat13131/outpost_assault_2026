@tool
class_name Spawner extends Node2D

## This Spawner is participating in the wave.
signal spawner_started(spawner: Spawner)
## This Spawner is done participating in the wave.
signal spawner_stopped(spawner: Spawner)

signal enemy_spawned(unit: EnemyUnit)

@export var spawn_points : Array[SpawnPoint] = []
@export_category("Wave")
## Which level waves to participate in. No entries means every wave. 
@export var _waves : Array[int]
## Used to stager when spawners start within the same wave
@export var _inital_delay : float = 0.05
## Seconds between Pulses
@export_range(0.5, 5.0, .5) var _pulse_gap := 2.0
## How many pulse are going to spawn for this wave. -1 is infinite. 
@export_range(-1, 100, 1) var _pulse_per_wave: int = 10
## How many pulse started so far
var _started_pulse_count := 0
## Use with _enemies_per_pulse
var _enemy_spawned_count := 0 
## Hard enemy limit - if would go over this limit, spawning is skipped. Espeically 
## important for infinit spaws to prevent freezing. Also used to preserve rarity of certain spawns.
@export_range(1,100,1) var _hard_spawn_cap := 100
## Use with _hard_spawn_cap to limit spawns
var _active_enemy_count:= 0
## Seconds between spawning units within the pulse
@export_range(0.1, 10.0, .01) var _spawn_speed := 1.5
## How many units spawn in each pulse
@export_range(1,100, 1) var _pulse_unit_volume: int = 1

@export var spawn_types : Dictionary[EnemyUnitInfo.EnemyTypes, int] = {}

## Parent node for spawned units get added to as children.
var _unit_container: Node2D: set = set_unit_container, get = get_unit_container

var _is_pulse_active := false
## Used to indicate the Spawn Point is destroyed
var _is_disabled := false 

var _picker : WeightedPicker

@onready var _timer := TimerModded.new(_inital_delay)

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	add_child(_timer) 
	_timer.timeout.connect(_on_timer_timeout)
	_populate_spawn_points()
	_picker = WeightedPicker.new(spawn_types)

func _draw() -> void:
	if !Engine.is_editor_hint():
		return
	for each in spawn_points:
		draw_line(
			Vector2.ZERO, to_local(each.global_position), Color.AQUA, 5.0
		)

func _populate_spawn_points() -> void:
	for each_child in get_children():
		if each_child is SpawnPoint:
			if !each_child.is_disabled:
				if !spawn_points.has(each_child):
					spawn_points.append(each_child)
	while spawn_points.has(null): # because this problem has come up
		spawn_points.erase(null)

func start_wave(wave_number) -> void:
	#prints(self, wave_number, _waves.is_empty() , _waves.has(wave_number))
	if _is_disabled:
		return
	if _waves.is_empty() or _waves.has(wave_number):
		_enemy_spawned_count = 0
		_started_pulse_count = 0
		_timer.set_wait_time(_inital_delay)
		_timer.start()
		spawner_started.emit(self)

func _start_pulse() -> void:
	
	# Clear to start
	if (_started_pulse_count < _pulse_per_wave) or (_pulse_per_wave < 0):
		_started_pulse_count += 1
		_is_pulse_active = true
		_enemy_spawned_count = 0
		_timer.set_wait_time(_spawn_speed)
		_timer.start()
		_spawn_new_enemy(_pick_enemy())
	# pulses are compelte
	else: 
		_end_wave()

func _pulse_complete() -> void:
	_is_pulse_active = false
	# infinate makes pulses come faster for challenge 
	if _pulse_per_wave < 0: 
		_pulse_gap *= .97
	_timer.set_wait_time(_pulse_gap)
	_timer.start()

func _check_pulse() -> void:
	if _enemy_spawned_count < _pulse_unit_volume:
		_timer.set_wait_time(_spawn_speed)
		_timer.start()
	else:
		_pulse_complete()

func set_unit_container(node: Node2D) ->void: _unit_container = node

func get_unit_container() -> Node2D:
	if _unit_container: 
		return _unit_container
	return self

func _on_timer_timeout() -> void:
	if _is_disabled:
		return
	if _is_pulse_active:
		_spawn_new_enemy(_pick_enemy())
	elif !_is_pulse_active:
		_start_pulse()

func _spawn_new_enemy(enemy_type: EnemyUnitInfo.EnemyTypes) -> void:
	if _active_enemy_count >= _hard_spawn_cap:
		# skip this spawn, restart correct kind of timer
		_check_pulse()
		return
	var next_enemy_path: = EnemyUnitInfo.get_enemy_scene_path(enemy_type)
	if !next_enemy_path:
		push_error("Failed to get enemy scene path")
		return
	var next_enemy_packed_scene: PackedScene = load(next_enemy_path)
	var next_enemy_instance: EnemyUnit = next_enemy_packed_scene.instantiate()
	var spawn_point : SpawnPoint = _get_spawn_point(EnemyUnitInfo.EnemySpawnTypes.PERSON) # TODO dynamic type
	next_enemy_instance.set_position(spawn_point.get_target_location())
	get_unit_container().add_child(next_enemy_instance)
	# set_nav_target doesn't work if happening before child_add.
	next_enemy_instance.set_nav_target(spawn_point.get_next_point())
	next_enemy_instance.died.connect(_on_unit_death)
	_active_enemy_count += 1
	_enemy_spawned_count += 1
	enemy_spawned.emit(next_enemy_instance)
	_check_pulse()

func _get_spawn_point(enemy_type: EnemyUnitInfo.EnemySpawnTypes) -> SpawnPoint:
	if spawn_points.is_empty():
		push_warning(self, " has no spanw_points")
		return null
	spawn_points.shuffle() 
	for each_point in spawn_points:
		if each_point:
			if each_point.is_type_valid(enemy_type):
				return each_point
	push_warning(self, " no spawn point match with enemey type: ", enemy_type)
	return spawn_points[0]

func _pick_enemy() -> EnemyUnitInfo.EnemyTypes: return _picker.pick_one()

func _end_wave() -> void: spawner_stopped.emit(self)

func _on_unit_death(_unit) -> void: _active_enemy_count -= 1

class WeightedPicker:
	var _total: float = 0
	var _choices: Dictionary[EnemyUnitInfo.EnemyTypes, int]
	
	func _init(dict : Dictionary[EnemyUnitInfo.EnemyTypes, int]) -> void: 
		populate_choices(dict)
	
	func pick_one() -> EnemyUnitInfo.EnemyTypes:
		if _choices.is_empty():
			return EnemyUnitInfo.EnemyTypes.DEBUG_WALKER
		if _choices.size() == 1:
			return _choices.keys()[0]
		var roll : float = randf_range(0, _total)
		var current_weight : float = 0
		for key in _choices.keys():
			current_weight = _choices[key]
			if roll <= current_weight:
				return key
			roll -= current_weight
		return EnemyUnitInfo.EnemyTypes.DEBUG_WALKER

	## clearing out any 0 entries 
	func populate_choices(dict : Dictionary[EnemyUnitInfo.EnemyTypes, int]) -> void: 
		var weight: int
		if _total != 0:
			push_warning("_total didn't start at 0") # because I removed _total = 0.0 and want to make sure i don't need it
		for key in dict.keys().duplicate():
			weight = dict[key]
			if weight > 0:
				_choices[key] = weight
				_total += weight
