class_name popup_buttons extends ButtonEnhanced

@export var _popup_type: LevelPopUps.PopupTypes

func _ready() -> void:
	super._ready()
	set_text(str(_popup_type))

func _on_pressed() -> void:
	LevelPopUps.request_popup(_popup_type)
