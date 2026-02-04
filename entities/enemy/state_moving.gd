@tool
class_name State_Moving extends UnitAtomicState


func _ready() -> void:
	if Engine.is_editor_hint():
		set_name("Moving")
	state_physics_processing.connect(_on_state_physics_processing)
	state_entered.connect(_on_state_entered)

func _on_state_entered()-> void:
	get_unit().request_animation(AnimatedSprite2DModded.ANIMATION_WALKING)

func _on_state_physics_processing(_delta: float) -> void:
	_delta *= GameSpeed.get_delta_mod()
	get_unit().move(_delta)
