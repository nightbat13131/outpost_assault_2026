class_name SpawnerBuilding extends Spawner
## Setup reminder: Set the Selction buttion size and location
## TODO: figure out how to have units walk around buildings while keeping that 
## enemies can walk OUT of buildings. Prototype just put buildings onto of non_walking places.
## TODO : leave behind ruble to build into tower after _die



@export var max_health : float = 100
@onready var _health : float = max_health : set = _set_health

var _health_ui: HealthUI 
@onready var ground_sprite_2d: Sprite2D = %GroundSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
var _button: Button_Trigger_UI
var _display_info: DisplayHelper
@onready var foundation_points: BrokenFoundationSpawner = %FoundationPoints

func _ready() -> void:
	super._ready()
	for each_child in get_children():
		if each_child is Button_Trigger_UI:
			_button = each_child
			_button.selected.connect(_on_selected)
		if each_child is HealthUI:
			_health_ui = each_child
			_set_health(max_health)
	if _health_ui and _button:
		_display_info = DisplayHelper.new(self, _health_ui)

func take_damage(value : float) -> void:
	_health -= value

func _set_health(value : float) -> void:
	_health = value
	if _health_ui:
		_health_ui.set_health_ratio(_health / max_health)
	if _health <= 0.0:
		_die()

func _die() -> void:
	animated_sprite_2d.play(AnimatedSprite2DModded.ANIMATION_DIE)
	_is_disabled = true
	if Engine.is_editor_hint():
		return
	await  animated_sprite_2d.animation_finished
	foundation_points.activate(_display_info)
	_end_wave()
	queue_free()

func get_display_info() -> DisplayHelper: return _display_info

func _on_selected() -> void: 
	DisplaySelected.request_display(_display_info)
	PurchaseInterface.disable()
