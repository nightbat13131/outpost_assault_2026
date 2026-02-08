class_name GameLevelUI extends CanvasLayer

static var _instance : GameLevelUI
@onready var level_viewport: SubViewport = %LevelViewport



func _ready() -> void:
	_instance = self
	print("a")

static func get_current_ui() -> GameLevelUI:
	return _instance

static func request_subviewport() -> SubViewport: 
	if get_current_ui():
		return _instance.level_viewport
	return null
