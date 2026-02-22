class_name RadarSensor extends Area2D

const RADAR_FADE := .25

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

var _radar_preview: float = 2.0
var _radar_outer_range := 2.0
var _targets : Array =[]
var _upgrades : FoundationUpgrades
#var _show_range := false

func _ready() -> void:
	collision_shape_2d.set_shape(CircleShape2D.new())

func has_target() -> bool: return !_targets.is_empty()

func on_tower_died() -> void: set_radar_outer_range(0.0)

func set_radar_outer_range(range_: float) -> void: 
	_radar_outer_range = range_
	collision_shape_2d.get_shape().set_radius(range_)
	queue_redraw()

func set_target_types(target_collition_mask: int) -> void:
	set_collision_mask(target_collition_mask)
	#TODO: recalculate targets in current area

func set_target_logic() -> void:pass

func get_target() -> void: pass

func preview_radar_range_tower(tower_type:= TowerInfo.TowerType.NA) -> void: 
	if TowerInfo.TowerType.NA:
		_radar_preview = 0.0
	else:
		_radar_preview = TowerInfo.get_radar_range(tower_type, _upgrades)
	queue_redraw()

func _draw() -> void:
	if _radar_preview >= 5.0:
		draw_circle(
			Vector2.ZERO, 
			_radar_preview, 
			Color(Utilties.COLOR_RADAR_PREVIEW, RADAR_FADE), 
			false, 5.0
	)
	if _radar_outer_range > 5.0:
		draw_circle(
			Vector2.ZERO, 
			_radar_outer_range, 
			Color(Utilties.COLOR_RADAR_FILL, RADAR_FADE)
		)

func _on_upgrades_change() -> void: queue_redraw()

func set_upgrade(upgrades: FoundationUpgrades) -> void:
	_upgrades = upgrades
	if _upgrades:
		if !_upgrades.upgrade_change.is_connected(_on_upgrades_change):
			_upgrades.upgrade_change.connect(_on_upgrades_change)
	queue_redraw()
