@tool
class_name CameraBounds extends Resource

const LINE_WIDTH = 10.0

@export var west_north := Vector2.ZERO:
	set(value):
		west_north = value
		emit_changed()
@export var east_south := Vector2(900,1200): 
	set(value):
		east_south = value
		emit_changed()
@export var camera_zoom : float = -1.0
@export var camera_start := Vector3(0.0, 30.0, 0.0) :
	set(value):
		camera_start = value
		emit_changed()

func get_north() -> float: return west_north.y

func get_west() -> float: return west_north.x

func get_south() -> float: return east_south.y

func get_east() -> float: return east_south.x

func setup_bars(north_bar: VisibleOnScreenNotifier3D, south_bar: VisibleOnScreenNotifier3D, east_bar: VisibleOnScreenNotifier3D, west_bar: VisibleOnScreenNotifier3D) -> void:
	for each_bar in [north_bar, south_bar, east_bar, west_bar]:
		each_bar.position = Vector3.ZERO
	print(north_bar, south_bar, east_bar, west_bar)
	north_bar.aabb = AABB(Vector3(get_west()*-1, -1, get_north()*-1), Vector3(get_west() + get_east(), 1, -1))
	south_bar.aabb = AABB(Vector3(get_west()*-1, -1, get_south()), 	  Vector3(get_west() + get_east(), 1, 1))
	east_bar.aabb  = AABB(Vector3(get_east(),    -1, get_north()*-1), Vector3(1, 1, get_north()+get_south()))
	west_bar.aabb  = AABB(Vector3(get_west()*-1, -1, get_north()*-1), Vector3(-1, 1,get_north()+get_south()))

func get_camera_starting_position() -> Vector3: 
	return camera_start

func draw_bounds(color:= Color.WHITE, index  := 1.0) -> void:
	index += 1
	var camera_center := get_camera_starting_position()
	DebugDraw3D.draw_sphere(camera_center, 1, color )
	DebugDraw3D.draw_line(camera_center, camera_center * Vector3(1,-1,1), color)
	DebugDraw3D.draw_box(Utilities.shift_2d_to_3d(west_north*-1, Vector3.DOWN*index), Quaternion.IDENTITY, Utilities.shift_2d_to_3d(west_north + east_south, Vector3.DOWN* index ), color)
	
