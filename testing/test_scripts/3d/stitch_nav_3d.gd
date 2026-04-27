#@tool
extends Node

@export var nav_point: NavPoint3D
@export var mob: CharacterBody3D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if nav_point and mob:
		if mob is EnemyUnit:
			mob.set_nav_target(nav_point)
		elif mob.has_method("set_nav_target"):
			mob.set_nav_target(nav_point)
		else:
			push_error(mob, " does not have set_nav_target for testing")

func _get_configuration_warnings() -> PackedStringArray:
	var out : Array[String] = []
	if mob:
		if mob.has_method("set_nav_target"):
			#out.append("Mob does not have set_nav_target")
			pass
	else:
		out.append("Select a Mob")
	if nav_point == null:
		out.append("Select a nav_point")
	return out
