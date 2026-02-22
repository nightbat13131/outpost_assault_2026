extends SubViewport

@onready var level_viewport: SubViewport = %LevelViewport

func _ready() -> void:
	world_2d = level_viewport.world_2d
