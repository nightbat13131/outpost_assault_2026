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
			each_child.start_wave(1) # debug

func _on_child_entered_tree(node: Node) -> void:
	if node is EnemyUnit:
		node.died.connect(_on_enemy_unit_died)

func _on_enemy_unit_died(_unit: EnemyUnit) -> void:
	## TODO: does money earnings go here?
	_enemy_unit_count -= 1

func _on_spawner_start(spawner: Spawner) -> void: _active_spawners.append(spawner)

func _on_spawner_stop(spawner: Spawner) -> void:
	while _active_spawners.has(spawner):
		_active_spawners.erase(spawner)
	if _active_spawners.is_empty():
		print_debug("Wave Complete")
		pass
