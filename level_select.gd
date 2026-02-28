class_name LevelSelect extends Node2D

# https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html

static var _instance: LevelSelect: get = get_instance

static var _path : String
static var _last_path : String

@onready var sprite_2d: Sprite2D = %Sprite2D

func _ready() -> void:
	activate()
	_instance = self

func activate() -> void:
	set_physics_process(true)
	sprite_2d.hide()
	show()

func deactivate() -> void:
	hide()
	set_physics_process(false)

func _process(_delta: float) -> void:
	if !_path:
		return # not loading a level
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(_path, progress)
	print(status, progress)
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		print(progress[0])
	elif status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		GameLevelUI.show_level(ResourceLoader.load_threaded_get(_path))
		_loading_done()

func _loading_started() -> void:
	sprite_2d.show()

func _loading_done() -> void:
	sprite_2d.hide()
	_last_path = _path
	_path = ''

static func get_instance() -> LevelSelect: return _instance

static func request_level(file_path) -> void:
	if get_instance(): 
		if _path:
			push_warning("can not load path {0} as path {1} has already started loading".format([file_path, _path]))
			return
		_path = file_path
		ResourceLoader.load_threaded_request(_path)
		get_instance()._loading_started()
	else:
		push_warning("no loader instance to enact thing")

static func request_reload() -> void:
	if _last_path:
		request_level(_last_path)
	else:
		push_warning("LevelSelect.request_reload no last path to retry")

static func request_activate() -> void:
	if get_instance():
		get_instance().activate()
