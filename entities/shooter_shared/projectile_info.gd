class_name ProjectileInfo extends ProjectileInfo_reference

@export var _projectile_type := ProjectileType.BULLET
@export var _speed : float = 500.0
@export var _damage := 3.0
@export var _projectile_spread_deg := 1.0

func get_projectile() -> Projectile:
	var packed : PackedScene = load(get_projectile_type_path(_projectile_type))
	if packed:
		return packed.instantiate()
	return null

func get_speed() -> float: return _speed

func get_damage() -> float: return _damage

func get_projectile_spread_radian() -> float: return deg_to_rad(_projectile_spread_deg)
