class_name BrokenFoundation extends Sprite2D

const SCENE_PATH = "uid://bk5nrgy052rvw"
const BASE_REPAIR_DURATION = 2.0
var _button: Button_Trigger_UI
var _display_info: DisplayHelper
var _repair_started := false

@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var repair_timer: TimerModded = %Repair_Timer

var _repair_manager: RepairPurchaser

func _ready() -> void:
	texture_progress_bar.set_as_ratio(1.0)
	for each_child in get_children():
		if each_child is Button_Trigger_UI:
			_button = each_child
			_display_info = DisplayHelper.new(self, null)
			var size := get_texture().get_size() * .9
			_button.set_size(size)
			_button.set_position(size*-.5)
			_button.selected.connect(on_selected)
		if each_child is RepairPurchaser:
			_repair_manager = each_child
			_repair_manager.start_repair.connect(_do_repair)

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

func _repair_complete() -> void:
	texture_progress_bar.hide()
	queue_free()
	var new_ = load(TowerFoundation.SCENE_PATH).instantiate() as TowerFoundation
	var _parent = TowerHolder.get_instance()
	if !_parent:
		push_error("Parent missing for TowerHolder.")
		return
	new_.set_global_position(global_position)
	_parent.add_child(new_)
	if DisplaySelected.replace_information(_display_info, new_.get_display_info()):
		new_.on_selected()

func _get_repair_duration() -> float: return BASE_REPAIR_DURATION

func on_selected() -> void:
	DisplaySelected.request_display(_display_info)
	_repair_manager.on_select()
