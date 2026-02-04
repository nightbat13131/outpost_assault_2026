@tool 
class_name State_Death extends UnitAtomicState

func _ready() -> void:
	if Engine.is_editor_hint():
		set_name("Death")
