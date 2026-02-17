class_name DisplaySelected  extends Control

static var _instance: DisplaySelected
static var _null_information : DisplayHelper

var _information : DisplayHelper
@onready var display_name: Label = %DisplayName
@onready var display_health: ShadowHealthUI = %Display_Health
@onready var display_selected_viewport: DisplaySelected_SubViewport = %DisplaySelectedViewport
#@onready var purchase_interface: PurchaseInterface = %PurchaseInterface


@onready var display_nothing_button: Button = %DisplayNothing_Button

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

static func replace_information(old_info: DisplayHelper, new_info: DisplayHelper) -> bool:
	if old_info == new_info: 
		return false
	if get_instance():
		return get_instance()._replace_information(old_info, new_info)
	return false

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
		PurchaseInterface.disable()
	else:
		display_nothing_button.show()
	if _information == info: ## info already displaying
		# but allow for Health UI to change
		display_health.set_primary(_information.get_health_ui())
		return
	_information = info
	display_name.set_text(_information.get_display_name())
	display_health.set_primary(_information.get_health_ui())
	display_selected_viewport.set_camera_focus(_information.get_camera_position())

## Re-apply the information if the requesting info is the same object as current info
## Curreonly only allows health UI changes are called 
static func request_refresh(info: DisplayHelper) -> void:
	if get_instance():
		get_instance()._refresh_information(info)

## Apply the new information IF the old information matches the current display
## usecase example: broken foundation upgraded to tower. 
func _replace_information(old_info: DisplayHelper, new_info: DisplayHelper) -> bool:
	if old_info == _information:
		_apply_information(new_info)
		return true
	return false

## If the sent information is what's being displayed, remove it.
func _cancel_information(info: DisplayHelper) -> void:
	if info != _information: # no action needed
		return
	_apply_information(_null_information)

func _refresh_information(info: DisplayHelper) -> void:
	if info != _information: # no action needed
		return
	_apply_information(info)
