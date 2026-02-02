@tool
class_name State_Moving extends AtomicState

@export var unit : EnemyUnit

func _ready() -> void:
	if Engine.is_editor_hint():
		set_name("Moving")
	state_physics_processing.connect(_on_state_physics_processing)

func _on_state_physics_processing(_delta: float) -> void:
	_delta *= GameSpeed.get_delta_mod()
	if unit:
		unit.move(_delta)
