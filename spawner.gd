class_name Spawner extends Node2D

## This Spawner is participating in the wave.
signal spawner_started(spawner: Spawner)
## This Spawner is done participating in the wave.
signal spawner_stopped(spawner: Spawner)

signal enemy_spawned(unit: EnemyUnit)

enum EnemySpawnTypes {NA=0,
	PERSON = 100, VEHICLE_GROUN = 200, VEHICLE_AIR=300}




static var MapEnemyTypeMeta: Dictionary[EnemyUnitInfo.EnemyTypes, EnemySpawnTypes] = {
	EnemyUnitInfo.EnemyTypes.DEBUG_WALKER: EnemySpawnTypes.PERSON, 
	EnemyUnitInfo.EnemyTypes.SCOUT: EnemySpawnTypes.PERSON, 
	EnemyUnitInfo.EnemyTypes.GUN: EnemySpawnTypes.PERSON
}

@export_category("Wave")
## Which level waves to participate in. No entries means every wave. 
@export var _waves : Array[int]
## Used to stager when spawners start within the same wave
@export var _inital_delay : float = 0.05
## Seconds between Pulses
@export_range(0.5, 5.0, .5) var _pulse_gap := 2.0
# How many pulse are going to spawn for this wave
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
@export_range(0.1, 10.0, .01) var _spawn_speed := 0.2
# How many units spawn in each pulse
@export_range(1,100, 1) var _pulse_unit_volume: int = 1

## Parent node for spawned units get added to as children.
var _unit_container: Node2D: set = set_unit_container, get = get_unit_container
## Used to indicate the Spanw Point is destroyed
var _is_pulse_active := false
var _is_disabled := false 

@onready var _timer := TimerModed.new(_inital_delay)

func _ready() -> void:
	add_child(_timer) 
	_timer.timeout.connect(_on_timer_timeout)

func start_wave(wave_number) -> void:
	if _is_disabled:
		return
	if _waves.is_empty() or _waves.has(wave_number):
		_timer.set_wait_time(_inital_delay)
		_timer.start()
		spawner_started.emit(self)

func _start_pulse() -> void:
	_started_pulse_count += 1
	if (_started_pulse_count < _pulse_per_wave) or (_pulse_per_wave < 0):
		_is_pulse_active = true
		_enemy_spawned_count = 0
		_timer.set_wait_time(_spawn_speed)
		_timer.start()
		_spawn_new_enemy(_pick_enemy())

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
	var next_enemy_path: = EnemyUnitInfo.get_enemy_scene_path(enemy_type)
	if !next_enemy_path:
		push_error("Failed to get enemy scene path")
		return
	var next_enemy_packed_scene: PackedScene = load(next_enemy_path)
	var next_enemy_instance: EnemyUnit = next_enemy_packed_scene.instantiate()
	var spawn_point : SpawnPoint = _get_spawn_point(EnemySpawnTypes.PERSON)
	next_enemy_instance.set_position(spawn_point.get_target_location())
	get_unit_container().add_child(next_enemy_instance)
	# set_nav_target doesn't work if happening before child_add.
	next_enemy_instance.set_nav_target(spawn_point.get_next_point())
	_active_enemy_count += 1
	_enemy_spawned_count += 1
	enemy_spawned.emit(next_enemy_instance)
	_check_pulse()

func _get_spawn_point(enemy_type: EnemySpawnTypes) -> SpawnPoint:
	for each_child in get_children():
		if each_child is SpawnPoint:
			if each_child.is_type_valid(enemy_type):
				## TODO: change this away from first only
				return each_child
	return null

func _pick_enemy() -> EnemyUnitInfo.EnemyTypes:
	return EnemyUnitInfo.EnemyTypes.DEBUG_WALKER

func _end_wave() -> void: spawner_stopped.emit(self)
