class_name AimingSights extends Node

var _rays : Array[RayCast2D] = []

func _ready() -> void:
	for each_child in get_children():
		if each_child is RayCast2D:
			each_child.set_collide_with_areas(true)
			each_child.set_collide_with_bodies(true)
			_rays.append(each_child)

func set_collision_mask_value(layer: int, flag:= true) -> void:
	for each_ray in _rays:
		each_ray.set_collision_mask_value(layer, flag)

func set_range(value: float) -> void:
	for each_ray in _rays:
		each_ray.target_position.x = value * 1.01

func is_colliding() -> bool:
	for each_ray in _rays:
		if each_ray.is_colliding():
			return true
	return false
