@tool
class_name CameraBinder extends Node3D

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
@export var camera : Camera3D_Enhanced

@onready var visible_on_screen_notifier_3d_west: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D_West
@onready var visible_on_screen_notifier_3d_north: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D_North
@onready var visible_on_screen_notifier_3d_south: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D_South
@onready var visible_on_screen_notifier_3d_east: VisibleOnScreenNotifier3D = %VisibleOnScreenNotifier3D_East

func _ready() -> void:
	testing_index = testing_index # prevent outout bounds
	if camera:
		camera.north_limit = visible_on_screen_notifier_3d_north
		camera.south_limit = visible_on_screen_notifier_3d_south
		camera.west_limit = visible_on_screen_notifier_3d_west
		camera.east_limit = visible_on_screen_notifier_3d_east
	if !Engine.is_editor_hint():
		trigger_bound_index(testing_index)
	else: 
		trigger_bound_index(0)

func _refresh_preview() -> void:
	trigger_bound_index(0)
	return
	if _redraw_press: pass # prevent unused variable warnings 
	if debug and camera:
		bound_index = clamp(testing_index, 0, bounds.size())

func _process(_delta: float) -> void:
	if !(Engine.is_editor_hint() or debug):
		return
	#DebugDraw3D.draw_sphere(Vector3.ZERO, 5, Color.ORANGE)
	var center: Vector3 = get_global_position()
	var color : Color
	var count = bounds.size()
	
	for index in range(count):
		color = Color.from_hsv(index/float(count), 1,1,1)
		bounds[index].draw_bounds(color, index)
		continue
		center = Utilities.shift_2d_to_3d(bounds[index].get_camera_starting_position(), Vector3.ZERO)
		
		DebugDraw3D.draw_sphere(
		center, 
		4.0, 
		color,
		#false, 2.0
		)

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
	bounds[index].setup_bars(visible_on_screen_notifier_3d_north, visible_on_screen_notifier_3d_south, visible_on_screen_notifier_3d_east, visible_on_screen_notifier_3d_west)
	
