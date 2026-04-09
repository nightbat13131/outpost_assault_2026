class_name LevelViewport extends SubViewport

enum Modes {NA = 0, _2D = 2, _3D = 3 }

var _sub_viewport_container: SubViewportContainer

func _ready() -> void:
	if get_parent() is SubViewportContainer:
		# Fixing this anit-practive would just move this code up one level
		_sub_viewport_container = get_parent()
	else:
		push_error("LevelViewport has a non SubViewportContainer parent")

func add_level(level: Level) -> void:
	for old in get_children():
		old.queue_free()
	add_child(level)
	var level_info = level.get_level_info()
	if !level_info:
		push_error("Level loaded without a Level info")
		return
	match level_info.get_levelviewport_mode():
		Modes._2D:
			configure_for_2d()
		Modes._3D:
			configure_for_3d()
		_:
			push_warning(level_info.get_level_name(), " does not have a levelviewport_mode configured.")

func deactivate() -> void:
	## TODO going to have to remove Level in smarter way?
	for old in get_children():
		old.queue_free()


func configure_for_3d() -> void:
	set_physics_object_picking(true) # mouse recognized with 3d area & body, but scrolling and other mouse clicks don't get picked up by GUIDE
	#_sub_viewport_container.set_mouse_target(false) # ??

func configure_for_2d() -> void:
	## middle mouse button pressed not being detected? 
	_sub_viewport_container.set_mouse_target(true) ## based on old configs
	set_physics_object_picking(false) # otherwise mouse scrolling not recognized in viewport
