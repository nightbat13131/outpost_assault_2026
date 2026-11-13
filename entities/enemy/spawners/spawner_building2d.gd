@tool
class_name SpawnerBuilding extends Spawner

## When building is detroyed, this builds the rubble. Set the rubble type on this object.
@onready var _foundation_points: BrokenFoundationSpawner = %FoundationPoints
## The building that is the body of this spawner
@onready var _building: Building2D = %Building
## Gold Reward when building is destroyed.
@export var _kill_reward := 300.0
## Starting health for the Building
@export var _building_health := 100.0

func _ready() -> void:
	super._ready()
	_setup_building()

func _setup_building() -> void:
	if Engine.is_editor_hint():
		return
	if _building.has_signal("died"):
		_building.set_max_health(_building_health)
		_building.died.connect(_on_building_died)
		
	else:
		prints(self, "somehow doesn't find died signal on ", _building)
	_building.set_collision_layer_value(RadarSensor.COLLISION_ENEMY_BUILDING, true)

func _on_building_died() -> void:
	_is_disabled = true
	_end_wave()
	_foundation_points.activate(_building.get_display_info())
	# TODO: effect building kill gold by unlocks
	GoldManager.earn_gold(_kill_reward)

func _death_animation_complete() -> void:
	if Engine.is_editor_hint():
		return
	_foundation_points.activate(_building.get_display_info())
	queue_free()
