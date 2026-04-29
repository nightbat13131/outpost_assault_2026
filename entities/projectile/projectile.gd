class_name Projectile extends Area3D

const LIFE_VS_RANGE : float = 1.0 ## because the muzzle is beyond the center, 100% still fices a bullet that goes a little beyond normal range

#var _speed: int
var _damage: float = 10.0
var _velocity := Vector3.FORWARD
var _target: Node2D  ## used by homing missiles
var _time_remaining := 10.0: set = _set_time_remaining

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	delta *= GameSpeed.get_delta_mod()
	if delta > 0.0:
		_time_remaining -= delta
		global_position += (_velocity * delta)

func setup(g_position: Vector3, rotation_y: float, speed: float, damage: float, max_distance: float, collition_mask: int, target: Node2D,) -> void:
	global_position = g_position
	rotation.y = rotation_y
	_damage = damage
	_target = target
	_set_time_remaining((max_distance / speed) * LIFE_VS_RANGE)
	set_collision_mask(collition_mask)
	#_velocity = Vector3.FORWARD.rotated(rotation) * speed # .RIGHT because that's the direction before rotation
	_velocity = Vector3.FORWARD.rotated(Vector3.UP, rotation_y) * speed


func _set_time_remaining(time: float) -> void:
	_time_remaining = time
	if _time_remaining <= 0:
		_die()

func _try_damage(node: Node3D) -> void:
	## ideally collition masks will keep from hitting the wrong objects
	if node.has_method("take_damage"):
		if node.take_damage(_damage):
			_die()

func _on_body_entered(body: Node3D) -> void: 
	_try_damage(body)

func _on_area_entered(area: Node3D) -> void: 
	_try_damage(area)

func _die() -> void:
	## TODO: small explotion ?
	set_physics_process(false)
	queue_free()
