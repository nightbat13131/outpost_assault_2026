@tool
class_name SpawnPoint extends NavPoint

@export var unit_types : Array[EnemyUnitInfo.EnemySpawnTypes] = [EnemyUnitInfo.EnemySpawnTypes.NA]

func is_type_valid(spawn_type: EnemyUnitInfo.EnemySpawnTypes) -> bool: return unit_types.has(spawn_type)
