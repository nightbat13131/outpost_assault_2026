@tool
extends StaticBody2D

@export var debug := true
@export var max_zoom := 2.0
@export var min_zoom := .5

func _ready() -> void:
	for each_child in get_children():
		if each_child is CameraMan:
			each_child.max_zoom = max_zoom
			each_child.min_zoom = min_zoom
			break

func _draw() -> void:
	for each_child in get_children():
		if each_child is CollisionShape2D:
			if each_child.get_shape() is WorldBoundaryShape2D:
				_draw_boarder_line(each_child)

func _draw_boarder_line(center: CollisionShape2D) -> void:
	var pos = center.position
	var radian = center.get_shape().get_normal().angle() + (PI*.5)
	draw_line(
		pos + Vector2.from_angle(radian) * 2000,
		pos +  Vector2.from_angle(radian) * -2000,
		Color.ALICE_BLUE, 2.0, false)
