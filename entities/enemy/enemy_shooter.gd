class_name EnemyShooter extends EnemyUnit


@export var _reload_info: ReloadInfo_Enemy

@onready var _shooter: Shooter = %Shooter
@onready var _clip_reload_ui: ClipReloadUI = %ClipReloadUI


func _ready() -> void:
	super._ready()
	_reload_info = _reload_info.duplicate()
	_clip_reload_ui.set_reload_info(_reload_info)
	_reload_info.set_shooter(_shooter)
	_shooter.set_clip_information(_reload_info)
	
	_shooter.set_range(150)
	_shooter.set_targetting_mask(RadarSensor.COLLISION_PLAYER_BUILDING)
	_maintain_rotation.append(_shooter)
	_shooter.get_radar_sensor().set_rotation_parent(self)

func send_event(event: String) -> void:
	super.send_event(event)
	if _shooter:
		_shooter.send_event(event)
