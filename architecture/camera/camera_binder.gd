@tool
class_name CameraBinder extends Node2D

var bound_index := 0

@export var debug := true
@export var testing_index := 0
@export var bounds : Array[CameraBounds] = []
@export_tool_button("Refresh", "CanvasLayer") var _redraw_press = queue_redraw
var camera : Camera2DEnhanced

func _ready() -> void:
	if _redraw_press: # prevent warnings
		pass
	for each_child in get_children():
		if each_child is Camera2DEnhanced:
			camera = each_child
			break
	if debug and camera:
		bound_index = clamp(testing_index, 0, bounds.size())
		camera.apply_bound(bounds[bound_index])

func _draw() -> void:
	var index := 0
	for each_bound in bounds:
		each_bound.draw_bounds(self, Color.from_hsv(index/float(bounds.size()), 1, 1 ))
		index += 1
