@tool
class_name CameraBinder extends Node2D

var bound_index := 0

@export var debug := true
@export var testing_index := 0 : 
	set(value): 
		if bounds.is_empty():
			testing_index = value
			return
		testing_index = abs(value % bounds.size())
		#testing_index = value
		_refresh_preview()

@export var bounds : Array[CameraBounds] = []
@export_tool_button("Refresh", "CanvasLayer") var _redraw_press = _refresh_preview
@export var camera : Camera2DEnhanced

func _ready() -> void:
	testing_index = testing_index # prevent outout bounds
	if !Engine.is_editor_hint():
		trigger_bound_index(testing_index)
	else: 
		trigger_bound_index(0)

func _refresh_preview() -> void:
	if _redraw_press: pass # prevent unused variable warnings 
	if debug and camera:
		bound_index = clamp(testing_index, 0, bounds.size())
		camera.set_bound(bounds[testing_index])
	queue_redraw()
	camera.queue_redraw()

func _draw() -> void:
	var index := 0
	for each_bound in bounds:
		each_bound.draw_bounds(self, Color.from_hsv(index/float(bounds.size()), 1, 1 ))
		index += 1

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:Array = [
		"Camera Bounds Empty"]
	if bounds.is_empty():
		return warnings
	return []

func trigger_bound_index(index: int) -> void:
	if index < 0:
		## -1 used to skip calling indexes
		return
	elif index >= bounds.size():
		push_error("CameraBinder.trigger_bound_index out of bound index called, ", index)
		return
	camera.set_bound(bounds[index])
		
