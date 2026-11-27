@tool
class_name CameraBinder extends Node2D

var bound_index := 0
@onready var _fog_of_war : FogOfWar = %FogOfWar

@export var debug := true
@export var _free_roam := false
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

static var _instance : CameraBinder

func _init() -> void:
	_instance = self
	tree_exiting.connect(_on_exiting_tree)

func _on_exiting_tree() -> void:
	_instance = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	testing_index = testing_index # prevent outout bounds
	if _free_roam:
		camera._debug_freeroam = true
	for each_bound in bounds:
		if !each_bound.changed.is_connected(queue_redraw):
			each_bound.changed.connect(queue_redraw)
	if debug:
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
	if _fog_of_war:
		_fog_of_war.apply_bounds(bounds[index])

func _trigger_camera_sync() -> void:
	camera.remote_move_to(DisplaySelected.get_ui_camera_pos())

static func has_instance() -> bool: return _instance != null

static func get_instance() -> CameraBinder: return _instance

## Tell the game camera to point at the same location as the UI camera
static func trigger_camera_sync() -> void:
	if has_instance():
		get_instance()._trigger_camera_sync()
