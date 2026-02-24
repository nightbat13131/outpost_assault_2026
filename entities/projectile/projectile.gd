class_name Projectile extends Area2D

const LIFE_VS_RANGE : float = 1.0 ## because the muzzle is beyond the center, 100% still fices a bullet that goes a little beyond normal range

#var _speed: int
var _damage: float
var _velocity: Vector2
var _target: Node2D  ## used by homing missiles
var _time_remaining := 10.0: set = _set_time_remaining

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	delta *= GameSpeed.get_delta_mod()
	if delta > 0.0:
		_time_remaining -= delta
		global_position += (_velocity * delta)

func setup(g_position: Vector2, rotation_: float, speed: float, damage: float, target: Node2D, max_distance: float) -> void:
	global_position = g_position
	rotation = rotation_
	#_speed = speed
	_damage = damage
	_target = target
	_set_time_remaining((max_distance / speed) * LIFE_VS_RANGE)
	_velocity = Vector2.RIGHT.rotated(rotation_) * speed # .RIGHT because that's the direction before rotation

func _set_time_remaining(time: float) -> void:
	_time_remaining = time
	if _time_remaining <= 0:
		_die()

func _on_body_entered(body: Node2D) -> void:
	#if area.has_method("take_damange"):
	if body is EnemyUnit:
		body.take_damage(_damage)
		## TODO: small explotion ?
		_die()

func _die() -> void:
	set_physics_process(false)
	queue_free()
