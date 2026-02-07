@tool
class_name CameraBinder extends Node2D

var bound_index := 0

@export var debug := true
@export var testing_index := 0
@export var bounds : Array[CameraBounds] = []
var camera : Camera2DEnhanced

func _ready() -> void:
	for each_child in get_children():
		if each_child is Camera2DEnhanced:
			camera = each_child
			break
	if debug:
		bounds[clamp(testing_index, 0, bounds.size())].apply_to_camera(camera)

func _draw() -> void:
	var index := 0
	for each_bound in bounds:
		each_bound.draw_bounds(self, Color.from_hsv(index/float(bounds.size()), 1, 1 ))
		index += 1

func _draw_boarder_line(center: CollisionShape2D) -> void:
	var pos = center.position
	var radian = center.get_shape().get_normal().angle() + (PI*.5)
	draw_line(
		pos + Vector2.from_angle(radian) * 2000,
		pos +  Vector2.from_angle(radian) * -2000,
		Color.ALICE_BLUE, 2.0, false)
