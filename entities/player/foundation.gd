@abstract
class_name Foundation extends Node2D

signal selected(node: Foundation)

enum FoundationType {NA = 0, OG = 1 }


@warning_ignore("unused_private_class_variable")
var _display_info: DisplayHelper : get = get_display_info
var _is_selected : bool

@onready var _select_button: Button_Trigger_UI = %Button

func _ready() -> void:
	_select_button.selected.connect(on_selected)
	_post_ready.call_deferred() 

@abstract func _post_ready() -> void

@abstract func get_display_info() -> DisplayHelper

func on_selected() -> void: _set_is_selected(true)

func _set_is_selected(is_selected: bool) -> void:
	_is_selected = is_selected
	if _is_selected:
		DisplaySelected.request_display(get_display_info())
		selected.emit(self)

#func on_selected() -> void:
	#if _is_selected:
		#print("try repair")
		#if !is_repairing():
			#if GoldManager.attempt_purchase(get_build_cost()):
				#_do_repair()
		#_repair_manager.remote_update_buttons()
	#else:
		#_is_selected = DisplaySelected.request_display(_display_info)
		#if _is_selected:
			#selected.emit(self)
	#_update_buttons()

func _on_selection_cancled() -> void: 
	_set_is_selected(false)
