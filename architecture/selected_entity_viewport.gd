class_name DisplaySelected_SubViewport extends SubViewport

@export var world_source : SubViewport
@onready var camera_2d: Camera2D = %Camera2D


func _ready() -> void:
	if world_source:
		world_2d = world_source.world_2d# get_tree().root.get_world_2d()

func set_camera_focus(position: Vector2) -> void:
	 ## TODO: camera shutter when changing locations
	if position == DisplayHelper.DEFAULT_POS:
		camera_2d.position = Vector2.ZERO
		get_parent().hide()
	else: 
		camera_2d.position = position
		get_parent().show()
