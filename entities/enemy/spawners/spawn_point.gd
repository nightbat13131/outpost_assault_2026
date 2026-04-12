@tool
class_name SpawnPoint extends NavPoint

@export var unit_types : Array[EnemyUnitInfo.EnemySpawnTypes] = [EnemyUnitInfo.EnemySpawnTypes.NA]

func _ready() -> void:
	super._ready()
	for each_child in get_children():
		if each_child is NavPoint:
			if !each_child.is_disabled:
				if !next_targets.has(each_child):
					next_targets.append(each_child)

func is_type_valid(spawn_type: EnemyUnitInfo.EnemySpawnTypes) -> bool: return unit_types.has(spawn_type)
