class_name AimingSights extends Node

func _ready() -> void:
	for each_child in get_children():
		if each_child is RayCast2D:
			each_child.set_collide_with_areas(true)
			each_child.set_collide_with_bodies(true)


func set_range(value: float) -> void:
	for each_child in get_children():
		if each_child is RayCast2D:
			each_child.target_position.x = value * 1.01 ## TODO does this need a buffer?

func is_colliding() -> bool:
	for each_child in get_children():
		if each_child is RayCast2D:
			if each_child.is_colliding():
				return true
	return false
