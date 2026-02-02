@tool
class_name SpawnPoint extends NavPoint

@export var unit_types : Array[Spawner.EnemySpawnTypes] = [Spawner.EnemySpawnTypes.NA]

func is_type_valid(spawn_type: Spawner.EnemySpawnTypes) -> bool: return unit_types.has(spawn_type)
