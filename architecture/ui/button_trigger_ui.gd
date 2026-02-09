class_name Button_Trigger_UI extends ButtonEnhanced

var _info : DisplayHelper

func set_display_info(info: DisplayHelper) -> void:
	_info = info

func _on_pressed() -> void: _request_ui_display()

func _request_ui_display() -> void:
	DisplaySelected.request_display(_info)
