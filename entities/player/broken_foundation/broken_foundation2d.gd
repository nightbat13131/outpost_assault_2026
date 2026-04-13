class_name BrokenFoundation2D extends Sprite2D

const SCENE_PATH = "uid://bk5nrgy052rvw"
const BASE_REPAIR_DURATION = 2.0
const TOOLTIP_NAME = 'Broken Foundation'
const TOOLTIP_REPAIR = TOOLTIP_NAME + ": \n${0} Repair"
const TOOLTIP_REPAIRING = TOOLTIP_NAME + ": \nRepairing"

@export var _cost_info: CostButtonInfo_BrokenFoundation

var _display_info: DisplayHelper
var _repair_started := false
var _is_selected := false

@onready var _select_button: Button_Trigger_UI = %Button
@onready var _repair_manager: RepairPurchaser = %RepairManager
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var repair_timer: TimerModded = %Repair_Timer

func _ready() -> void:
	texture_progress_bar.set_as_ratio(1.0)
	_cost_info = _cost_info.duplicate()
	_repair_manager.start_repair.connect(_do_repair)
	_repair_manager.set_broken_foundation(self, null)
	_repair_manager.set_cost_info(_cost_info)
	_display_info = DisplayHelper.new(self, null, _repair_manager, null)
	_display_info.unselected.connect(_on_selection_cancled)
	_select_button.selected.connect(on_selected)
	_update_buttons()

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
	_update_buttons()
	repair_timer.set_wait_time(_get_repair_duration())
	repair_timer.timeout.connect(_repair_complete)
	repair_timer.start()

func _repair_complete() -> void:
	texture_progress_bar.hide()
	queue_free()
	var new_ = load(TowerFoundation2D.get_packed_scene_path(_repair_manager.get_foundation_type())).instantiate() as TowerFoundation2D
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
	_update_buttons()

func _update_buttons() -> void:
	if is_repairing():
		_select_button.set_state(ButtonEnhanced.ButtonStates.Active)
		_select_button.set_tooltip_text(TOOLTIP_REPAIRING)
	elif _is_selected:
		_select_button.set_state(ButtonEnhanced.ButtonStates.Active_Overwrite)
		_select_button.set_tooltip_text(TOOLTIP_REPAIR.format([int(get_build_cost())])) #, "{}"))
	else:
		_select_button.set_state(ButtonEnhanced.ButtonStates.Active)
		_select_button.set_tooltip_text(TOOLTIP_NAME)


func _on_selection_cancled() -> void: 
	_is_selected = false
	_update_buttons()

func set_foundation_type(foundation_type: TowerFoundation2D.FoundationType) -> void:
	_repair_manager.set_foundation_type(foundation_type)

static func get_build_cost() -> float: return 100.0
