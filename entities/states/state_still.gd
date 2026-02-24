@tool
class_name State_Still extends UnitAtomicState

func _ready() -> void:
	if Engine.is_editor_hint():
		set_name("Still")
	state_entered.connect(_on_state_entered)

func _on_state_entered()-> void:
	get_unit().stop_animation(AnimatedSprite2DModded.ANIMATION_WALKING)
