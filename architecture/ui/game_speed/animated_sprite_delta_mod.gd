class_name AnimatedSprite2DModded extends AnimatedSprite2D

const ANIMATION_WALKING = "walk"
const ANIMATION_DIE = "die"
const ANIMATION_SHOOT = "shoot"
const ANIMATION_IDLE = "idle"

const ANIMATION_DEFAULT = "default"

func _ready() -> void:
	_speed_manager_connect.call_deferred()

func _speed_manager_connect() -> void:
	var speed_manager = GameSpeed.get_instance()
	if speed_manager:
		speed_manager.speed_change.connect(_on_speed_change)
	else:
		push_error("AnimatedSprite2DModded not getting a speed manager to connect to")

func _on_speed_change(delta_mod : float) -> void:
	set_speed_scale(delta_mod)
