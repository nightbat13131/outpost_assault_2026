class_name CameraMan extends CharacterBody2D
## TODO clean up movement

@export var control_context : GUIDEMappingContext
@export var action_move : GUIDEAction
@export var action_zoom : GUIDEAction
@onready var camera_2d: Camera2D = %Camera2D

var _max_speed := 1000.0

func _ready() -> void:
	if control_context:
		GUIDE.enable_mapping_context(control_context)
	if action_zoom:
		action_zoom.triggered.connect(_on_zoom)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 25.0, Color.BLUE, false, 2.0, false)

func _physics_process(_delta: float) -> void:
	if action_move:
		if action_move.is_triggered():
			var direction := action_move.value_axis_2d.normalized()
			velocity = direction * _max_speed
			move_and_slide()

func _on_zoom() -> void:
	var value = action_zoom.value_axis_1d
	camera_2d.zoom *= 1.0 + (.1 * value)
