class_name TowerShooter extends Tower

var _shooter: Shooter
var _radar_sensor : RadarSensor

func setup(upgrades: FoundationUpgrades, health_ui: HealthUI, clip_reload_ui: ClipReloadUI) -> void:
	#print("B 1")
	super.setup(upgrades, health_ui, clip_reload_ui)
	for each_child in get_children(): # so that no every tower HAS to have a shooter
		if each_child is Shooter: 
			_shooter = each_child
			_radar_sensor = _shooter.get_radar_sensor()
			_shooter.set_reload_info(get_reload_info())
			_shooter.set_targetting_mask(RadarSensor.COLLISION_ENEMY_BUILDING)
			_shooter.set_targetting_mask(RadarSensor.COLLISION_ENEMY_HUMANS)
			_shooter.set_radar_shape(get_radar_shape())
			_shooter.set_projectile_info(get_tower_info().get_projectile_info())

func _set_radar_range() -> void:
	if _shooter:
		var _range = get_tower_info().get_outer_range()
		#_shooter.set_range(_range)
		get_radar_shape().set_outer_radius(_range)

func _on_upgrade_changed() -> void:
	super._on_upgrade_changed()
	_set_radar_range()

func has_shooter() -> bool: return true

func set_parent_hovered(is_hover: bool ) -> void:
	_shooter.set_parent_hovered(is_hover)

func set_parent_selected(is_selected: bool) -> void:
	_shooter.set_parent_selected(is_selected)
