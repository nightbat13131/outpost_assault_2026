class_name Spawner extends Node2D

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
## Seconds between spawning or Pulses 
@export_range(0.5, 5.0, .5) var _wave_speed := 2.0


# Toggle the usage of the MicroWave logic
@export var _pulse_waves_on := false

@export_group("Pulse_Waves", "_pulse_")


# Seconds between spawning units within the pulse
@export_range(0.1, 10.0, .01) var _pulse_speed := 0.2
# How many units spawn in each pulse
@export_range(1,100, 1) var _pulse_volume: int = 1


var _unit_container: Node2D: set = set_unit_container, get = get_unit_container

@onready var _spawn_timer := TimerModed.new(_inital_delay)

func _ready() -> void:
	add_child(_spawn_timer) 
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func start_wave(wave_number) -> void:
	if _waves.is_empty() or _waves.has(wave_number):
		_spawn_timer.start()

func set_unit_container(node: Node2D) ->void: _unit_container = node

func get_unit_container() -> Node2D:
	if _unit_container: 
		return _unit_container
	return self

func _on_spawn_timer_timeout() -> void:
	var next_enemy_path: = EnemyUnitInfo.get_enemy_scene_path(EnemyUnitInfo.EnemyTypes.DEBUG_WALKER)
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

func _get_spawn_point(enemy_type: EnemySpawnTypes) -> SpawnPoint:
	for each_child in get_children():
		if each_child is SpawnPoint:
			print(each_child.is_type_valid(enemy_type))
			if each_child.is_type_valid(enemy_type):
				
				return each_child
	return null
