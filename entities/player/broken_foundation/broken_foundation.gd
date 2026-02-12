class_name BrokenFoundation extends Sprite2D

const SCENE_PATH = "uid://bk5nrgy052rvw"
const BASE_REPAIR_DURATION = 2.0
var _button: Button_Trigger_UI
var _display_info: DisplayHelper
var _repair_started := false

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var repair_timer: TimerModded = %Repair_Timer

func _ready() -> void:
	texture_progress_bar.set_as_ratio(1.0)
	for each_child in get_children():
		if each_child is Button_Trigger_UI:
			_button = each_child
			_display_info = DisplayHelper.new(self, null)
			var size := get_texture().get_size() * .9
			_button.set_size(size)
			_button.set_position(size*-.5)
			_button.set_display_info(_display_info)
			break

func get_display_info() -> DisplayHelper: return _display_info

func _process(_delta: float) -> void:
	if _repair_started:
		texture_progress_bar.set_as_ratio(repair_timer.get_ratio())

func is_repairing() -> bool: return _repair_started

func _do_repair() -> void:
	if _repair_started: # prefent double start
		return 
	_repair_started = true
	repair_timer.set_wait_time(_get_repair_duration())
	repair_timer.timeout.connect(_repair_complete)
	repair_timer.start()
	await get_tree().create_timer(1.0).timeout

func _repair_complete() -> void:
	# TODO spawn tower base
	texture_progress_bar.hide()
	queue_free()

func _get_repair_duration() -> float: return BASE_REPAIR_DURATION

func _repair_fail() -> void:
	# warning blink?
	pass
