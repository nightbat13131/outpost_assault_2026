@tool
class_name SpawnPoint extends Node2D

## The types of units that are valid to spawn at this location.
@export var unit_types : Array[EnemyUnitInfo.EnemySpawnTypes] = [EnemyUnitInfo.EnemySpawnTypes.NA]
## For disabling the nav point when it has to be on screen but not being used. 
@export var is_disabled := false

func is_type_valid(spawn_type: EnemyUnitInfo.EnemySpawnTypes) -> bool: return unit_types.has(spawn_type)

func get_target_location() -> Vector2:
	return global_position
