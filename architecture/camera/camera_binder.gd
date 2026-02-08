@tool
class_name CameraBinder extends Node2D

var bound_index := 0

@export var debug := true
@export var testing_index := 0 : 
	set(value): 
		if bounds.is_empty():
			testing_index = value
			return
		testing_index = value % bounds.size()
		_refresh_preview()
@export var bounds : Array[CameraBounds] = []
@export_tool_button("Refresh", "CanvasLayer") var _redraw_press = _refresh_preview
@export var camera : Camera2DEnhanced

func _ready() -> void:
	if _redraw_press: # prevent warnings
		pass
	_refresh_preview()

func _refresh_preview() -> void:
	if debug and camera:
		bound_index = clamp(testing_index, 0, bounds.size())
		camera.set_bound(bounds[bound_index])
	queue_redraw()
	camera.queue_redraw()

func _draw() -> void:
	var index := 0
	for each_bound in bounds:
		each_bound.draw_bounds(self, Color.from_hsv(index/float(bounds.size()), 1, 1 ))
		index += 1
