class_name SpawnerBuilding extends Spawner
## TODO: figure out how to have units walk around buildings while keeping that 
## enemies can walk OUT of buildings. Prototype just put buildings onto of non_walking places.
## TODO : leave behind ruble to build into tower after _die


@export var max_health : float = 100
@onready var _health : float = max_health : set = _set_health

@onready var health_ui: HealthUI = %HealthUI
@onready var ground_sprite_2d: Sprite2D = %GroundSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	super._ready()
	_set_health(max_health) # to trigger UI update

func take_damage(value : float) -> void:
	_health -= value

func _set_health(value : float) -> void:
	_health = value
	if health_ui:
		health_ui.set_healt_ratio(_health / max_health)
	if _health <= 0.0:
		_die()

func _die() -> void:
	animated_sprite_2d.play(AnimatedSprite2DModded.ANIMATION_DIE)
	_is_disabled = true
	if Engine.is_editor_hint():
		return
	await  animated_sprite_2d.animation_finished
	_end_wave()
	queue_free()
