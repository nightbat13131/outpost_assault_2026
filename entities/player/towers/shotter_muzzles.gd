class_name ShooterMuzzles extends Node

func get_muzzle_location() -> Vector2:
	return get_child(0).get_global_position()
