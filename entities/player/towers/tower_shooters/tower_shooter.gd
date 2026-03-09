class_name TowerShooter extends Tower

var _shooter: Shooter
var _radar_sensor : RadarSensor

func _ready() -> void:
	super._ready()
	for each_child in get_children(): # so that no every tower HAS to have a shooter
		if each_child is Shooter: 
			_shooter = each_child
			_shooter.set_clip_information(get_reload_info())
			_radar_sensor = _shooter.get_radar_sensor()

func setup(upgrades: FoundationUpgrades, health_ui: HealthUI, clip_reload_ui: ClipReloadUI) -> void:
	super.setup(upgrades, health_ui, clip_reload_ui)
	await ready
	if _shooter:
		#_shooter.set_foundation_upgrades(_founation_upgrades)
		_shooter.set_targetting_mask(RadarSensor.COLLISION_ENEMY_BUILDING)
		_shooter.set_targetting_mask(RadarSensor.COLLISION_ENEMY_HUMANS)
		_shooter.set_radar_shape(get_radar_shape())
	#get_reload_info().set_foundation_upgrades(upgrades)
	clip_reload_ui.set_reload_info(get_reload_info())

func _set_radar_range() -> void:
	if _shooter:
		var _range = _get_tower_info().get_outer_range()
		_shooter.set_range(_range)

func _on_upgrade_changed() -> void:
	super._on_upgrade_changed()
	_set_radar_range()

func has_shooter() -> bool: return true
