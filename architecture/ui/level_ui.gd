class_name GameLevelUI extends CanvasLayer

static var _instance : GameLevelUI
@onready var level_viewport: SubViewport = %LevelViewport
@onready var full_screen: HBoxContainer = %FullScreen
@onready var level_controls: VBoxContainer = %LevelControls

@export var is_left = true

func _ready() -> void:
	_instance = self
	if is_left:
		full_screen.move_child(level_controls, 0)
	else: 
		full_screen.move_child(level_controls, -1)

static func get_current_ui() -> GameLevelUI:
	return _instance

static func request_subviewport() -> SubViewport: 
	if get_current_ui():
		return _instance.level_viewport
	return null
