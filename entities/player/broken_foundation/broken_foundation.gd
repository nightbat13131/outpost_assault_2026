class_name BrokenFoundation extends Sprite2D
## TODO: add tooltop when pressing again will trigger the rebuild

const SCENE_PATH = "uid://bk5nrgy052rvw"
const BASE_REPAIR_DURATION = 2.0

@export var _cost_info: CostButtonInfo_BrokenFoundation

var _display_info: DisplayHelper
var _repair_started := false
var _is_selected := false

@onready var _button: Button_Trigger_UI = %Button
@onready var _repair_manager: RepairPurchaser = %RepairManager
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var repair_timer: TimerModded = %Repair_Timer

func _ready() -> void:
	texture_progress_bar.set_as_ratio(1.0)
	_cost_info = _cost_info.duplicate()
	_repair_manager.start_repair.connect(_do_repair)
	_repair_manager.set_broken_foundation(self)
	_repair_manager.set_cost_info(_cost_info)
	_display_info = DisplayHelper.new(self, null, _repair_manager, null)
	_display_info.unselected.connect(_on_selection_cancled)
	_button.selected.connect(on_selected)
	_update_button()

func get_display_info() -> DisplayHelper: return _display_info

func _process(_delta: float) -> void:
	if _repair_started:
		texture_progress_bar.set_as_ratio(repair_timer.get_ratio())

func is_repairing() -> bool: return _repair_started

func _do_repair() -> void:
	if _repair_started: # prevent double start
		return 
	
	_repair_started = true
	_cost_info.is_repairing = true
	_update_button()
	repair_timer.set_wait_time(_get_repair_duration())
	repair_timer.timeout.connect(_repair_complete)
	repair_timer.start()

func _repair_complete() -> void:
	texture_progress_bar.hide()
	queue_free()
	var new_ = load(TowerFoundation.get_packed_scene_path(_repair_manager.get_foundation_type())).instantiate() as TowerFoundation
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
	if _is_selected:
		print("try repair")
		if !is_repairing():
			if GoldManager.attempt_purchase(get_build_cost()):
				_do_repair()
		_repair_manager.remote_update_buttons()
	else:
		_is_selected = DisplaySelected.request_display(_display_info)
	_update_button()

func _update_button() -> void:
	if _is_selected and !is_repairing():
		_button.set_state(ButtonEnhanced.ButtonStates.Active_Overwrite)
	else: 
		_button.set_state(ButtonEnhanced.ButtonStates.Active)

func _on_selection_cancled() -> void: 
	_is_selected = false
	_update_button()

func set_foundation_type(foundation_type: TowerFoundation.FoundationType) -> void:
	_repair_manager.set_foundation_type(foundation_type)

static func get_build_cost() -> float: return 100.0
