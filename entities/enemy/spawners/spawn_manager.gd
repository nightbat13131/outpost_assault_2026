class_name SpawnManager extends Node2D

const WAVE_END_PADDING = 1.0

signal wave_complete
signal wave_start(wave_number: int, building_count: int)

@export var _debug := false
var _current_wave: int
var _active_spawners: Array[Spawner] = []
var _enemy_unit_count := 0
var _summoned_enemy_count := 0 ## tracking for end of level readout
#@onready var _padding: SceneTreeTimer

func _ready() -> void:
	#_setup_padding_timer()
	child_entered_tree.connect(_on_child_entered_tree)
	for each_child in get_children():
		if each_child is Spawner:
			each_child.set_unit_container(self)
			each_child.spawner_started.connect(_on_spawner_start)
			each_child.spawner_stopped.connect(_on_spawner_stop)
	DisplayWaveUI.connect_spawn_manager(self)
	if _debug:
		print_debug("Debug on")
		call_wave(1)

func call_wave(wave_number: int) -> void:
#	_setup_padding_timer()
	_current_wave = wave_number
	# get_children instead of an array because this is not called often and the spawners get freed.
	for each_child in get_children():
		if each_child is Spawner:
			each_child.start_wave(_current_wave)

func _on_child_entered_tree(node: Node) -> void:
	if node is EnemyUnit:
		node.died.connect(_on_enemy_unit_died)
		_enemy_unit_count += 1
		_summoned_enemy_count += 1
		_wave_check.call_deferred()

func _on_enemy_unit_died(unit: EnemyUnit) -> void:
	GoldManager.earn_gold(unit.get_kill_reward())
	_enemy_unit_count -= 1
	_wave_check.call_deferred()

func _on_spawner_start(spawner: Spawner) -> void:
	_active_spawners.append(spawner)
	wave_start.emit(_current_wave, _active_spawners.size())

func _on_spawner_stop(spawner: Spawner) -> void:
	while _active_spawners.has(spawner):
		_active_spawners.erase(spawner)
	_wave_check.call_deferred()

func _wave_check() -> void:
#	if _padding.time_left > 0.0:
#		return
	print_debug("Spawner count: ", _active_spawners.size(), " enemy count: ", _enemy_unit_count)
	if _active_spawners.is_empty() and _enemy_unit_count <= 0:
		wave_complete.emit()
		print("Wave complete.")

func get_enemy_summoned_count() -> int: return _summoned_enemy_count
