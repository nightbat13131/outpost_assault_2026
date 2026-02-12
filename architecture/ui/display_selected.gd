class_name DisplaySelected  extends Control

static var _instance: DisplaySelected
static var _null_information : DisplayHelper

var _information : DisplayHelper
@onready var display_name: Label = %DisplayName
@onready var display_health: ShadowHealthUI = %Display_Health
@onready var display_selected_viewport: DisplaySelected_SubViewport = %DisplaySelectedViewport
@onready var purchase_interface: PurchaseInterface = %PurchaseInterface

@onready var display_nothing_button: Button = $DisplayNothing_Button



func _ready() -> void:
	_instance = self
	if _null_information == null:
		_null_information = DisplayHelper.new(null, null)
	_apply_information(null)

static func get_instance() -> DisplaySelected: return _instance

static func request_display(info: DisplayHelper) -> bool:
	if get_instance():
		get_instance()._apply_information(info)
		return true
	return false

static func replace_information(old_info: DisplayHelper, new_info: DisplayHelper) -> void:
	if old_info == new_info: 
		return
	if get_instance():
		get_instance()._replace_information(old_info, new_info)

static func cancle_display(info: DisplayHelper) -> void:
	if get_instance():
		get_instance()._cancel_information(info)

func _apply_information(info: DisplayHelper) -> void:
	if info == null: 
		# allows correctly processing when nothing is selected. 
		# leave _null_information protection at this layer incase internal null
		# like _replace_information can send. 
		info = _null_information
		display_nothing_button.hide()
	else:
		display_nothing_button.show()
	if _information == info: ## info already displaying
		return
	_information = info
	purchase_interface.interface_this(info.get_parent())
	display_name.set_text(_information.get_display_name())
	display_health.set_primary(_information.get_health_ui())
	display_selected_viewport.set_camera_focus(_information.get_camera_position())

## Apply the new information IF the old information matches the current display
## usecase example: broken foundation upgraded to tower. 
func _replace_information(old_info: DisplayHelper, new_info: DisplayHelper) -> void:
	if old_info == _information:
		_apply_information(new_info)

## If the sent information is what's being displayed, remove it.
func _cancel_information(info: DisplayHelper) -> void:
	if info != _information: # no action needed
		return
	_apply_information(_null_information)
