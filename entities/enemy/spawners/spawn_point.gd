@tool
class_name SpawnPoint extends Node2D

## The types of units that are valid to spawn at this location.
@export var unit_types : Array[EnemyUnitInfo.EnemySpawnTypes] = [EnemyUnitInfo.EnemySpawnTypes.NA]
## For disabling the nav point when it has to be on screen but not being used. 
@export var is_disabled := false

var _targets : Array[Node2D] = []
var _target_index := 0


func _ready() -> void:
	for each in get_children():
		if each is Node2D:
			_targets.append(each)
	if _targets.is_empty():
		_targets.append(self)

func is_type_valid(spawn_type: EnemyUnitInfo.EnemySpawnTypes) -> bool: return unit_types.has(spawn_type)

func get_target_location() -> Vector2:
	var out : Vector2
	out = _targets[_target_index].global_position
	_target_index += 1
	_target_index %= _targets.size()
	return out
