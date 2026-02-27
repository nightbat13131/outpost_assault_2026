@tool
class_name NoTarget extends ShooterAtomicState

@export var look_forward := false

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		set_name("NoTarget")
	state_processing.connect(_on_state_processing)

func _on_state_processing(delta: float) -> void:	
	delta *= GameSpeed.get_delta_mod()
	get_shooter().state_process(delta)
	if has_target():
		send_event(Shooter.EVENT_HAS_TARGET)
	elif look_forward:
		get_shooter().look_forward(delta)
