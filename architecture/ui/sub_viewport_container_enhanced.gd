extends SubViewportContainer

@onready var level_viewport: LevelViewport = %LevelViewport

func _ready() -> void:
	#configure_for_2d()
	configure_for_3d()

func configure_for_3d() -> void:
	level_viewport.set_physics_object_picking(true) # mouse recognized with 3d area & body, but scrolling and other mouse clicks get lost
	set_mouse_target(true)
	
	pass

func configure_for_2d() -> void:
	set_mouse_target(true)
	level_viewport.set_physics_object_picking(false) # otherwise mouse scrolling not recognized in viewport
	pass
