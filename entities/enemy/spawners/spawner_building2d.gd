@tool
class_name SpawnerBuilding extends Spawner
## TODO: figure out how to have units walk around buildings while keeping that 
## enemies can walk OUT of buildings. Prototype just put buildings onto of non_walking places.

@onready var _foundation_points: BrokenFoundationSpawner = %FoundationPoints
@onready var _building: Building2D = %Building
@export var _kill_reward := 300.0

func _ready() -> void:
	super._ready()
	_setup_building()

func _setup_building() -> void:
	_building.died.connect(_on_building_died)
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
