@tool
class_name HasTarget extends ShooterAtomicState

@export var aiming_sights: AimingSights
@export var ammo_available_state : AtomicState

func _ready() -> void:
	super._ready()
	if Engine.is_editor_hint():
		set_name("HasTarget")
	state_processing.connect(_on_state_processing)

func _on_state_processing(delta: float) -> void:
	delta *= GameSpeed.get_delta_mod()
	get_shooter().state_process(delta)	
	
	if !has_target():
		send_event(Shooter.EVENT_NO_TARGET)
		return

	var target = get_radar_sensor().get_target()
	if target:
		get_shooter().turn_towards(delta, target.get_global_position())
		if ammo_available_state:
			if ammo_available_state.active:
				get_shooter().try_shoot()
	else:
		push_error("ShooterAtomicState.HasTarget._on_state_processing target failed")
	#if aiming_sights:
		#if aiming_sights.is_colliding():
			#get_shooter().try_shoot()
