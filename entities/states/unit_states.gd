@tool
class_name UnitAtomicState extends AtomicState

@export var _unit : EnemyUnit

func set_unit(unit: EnemyUnit) -> void: _unit = unit

func get_unit() -> EnemyUnit : return _unit
