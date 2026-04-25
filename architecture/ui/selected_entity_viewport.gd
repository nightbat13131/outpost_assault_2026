class_name DisplaySelected_SubViewport extends SubViewport

@export var world_source : SubViewport
#@onready var camera_2d: Camera2D = %Camera2D
@onready var camera_3d: Camera3D = %Camera3D

func _ready() -> void:
	_no_display() 
	if world_source:
		world_2d = world_source.world_2d# get_tree().root.get_world_2d()
		world_3d = world_source.world_3d

func set_camera_focus(info: DisplayHelper) -> void:
	#if info.is_2d():
		#_set_camera_focus_2d(info.get_camera_position2d())
	if info:
	#if info.is_3d():
		_set_camera_focus_3d(info.get_camera_position3d())
	else:
		_no_display()

func _no_display() -> void:
	camera_3d.position = Vector3.ZERO
	#camera_2d.position = Vector2.ZERO
	get_parent().hide()

func _set_camera_focus_3d(cam_position: Vector3) -> void:
	 ## TODO: camera shutter when changing locations
	if cam_position == DisplayHelper.DEFAULT_POS_3D:
		_no_display()
	else: 
		cam_position.y = 10 #camera_3d.position.y
		camera_3d.position = cam_position
		get_parent().show()

#func _set_camera_focus_2d(cam_position: Vector2) -> void:
	 ### TODO: camera shutter when changing locations
	#if cam_position == DisplayHelper.DEFAULT_POS_2D:
		#_no_display()
	#else: 
		#camera_2d.position = cam_position
		#get_parent().show()
