class_name EnemyShooter extends EnemyUnit

@onready var _shooter: Shooter = %Shooter
@onready var _clip_reload_ui: ClipReloadUI = %ClipReloadUI

func _ready() -> void:
	super._ready()
	_clip_reload_ui.set_reload_info(get_reload_info())
	_shooter.set_reload_info(get_reload_info())
	_shooter.set_targetting_mask(RadarSensor.COLLISION_PLAYER_BUILDING)
	_shooter.set_radar_shape(get_enemy_info().get_radar_shape())
	_shooter.set_projectile_info(get_enemy_info().get_projectile_info())
	_maintain_rotation.append(_shooter)
	_shooter.get_radar_sensor().set_rotation_parent(self)

func send_event(event: String) -> void:
	super.send_event(event)
	if _shooter:
		_shooter.send_event(event)
