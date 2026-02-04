class_name SpawnManager extends Node2D

var _active_spawners: Array[Spawner] = []
var _enemy_unit_count := 0

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	for each_child in get_children():
		if each_child is Spawner:
			each_child.set_unit_container(self)
			each_child.spawner_started.connect(_on_spawner_start)
			each_child.spawner_stopped.connect(_on_spawner_stop)
	call_wave(1) # debug

func call_wave(wave_number: int) -> void:
	for each_child in get_children():
		if each_child is Spawner:
			each_child.start_wave(wave_number)

func _on_child_entered_tree(node: Node) -> void:
	if node is EnemyUnit:
		node.died.connect(_on_enemy_unit_died)
		_enemy_unit_count += 1
		_wave_check()

func _on_enemy_unit_died(_unit: EnemyUnit) -> void:
	## TODO: does money earnings go here?
	_enemy_unit_count -= 1
	_wave_check()

func _on_spawner_start(spawner: Spawner) -> void: _active_spawners.append(spawner)

func _on_spawner_stop(spawner: Spawner) -> void:
	while _active_spawners.has(spawner):
		_active_spawners.erase(spawner)
	_wave_check()

func _wave_check() -> void:
	#print_debug("Spawner count: ", _active_spawners.size(), " enemy count: ", _enemy_unit_count)
	if _active_spawners.is_empty() and _enemy_unit_count <= 0:
		print("Wave complete.")
