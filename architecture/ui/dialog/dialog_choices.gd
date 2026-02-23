class_name DisplayDialogOptions extends VBoxContainer

signal complete

@onready var option_buttons : Array[ButtonEnhanced] = [%ButtonEnhanced, %ButtonEnhanced2, %ButtonEnhanced3]

var _is_active := false

func _ready() -> void:
	for each in option_buttons:
		each.pressed.connect(_on_option_pressed)
	_deactivate(true)

func set_info(info: DialogInfo) -> void:
	if info.has_choices():
		_activate()
		for index in range(option_buttons.size()):
			option_buttons[index].set_text(info.get_choices(index))
	else:
		_deactivate()

func _activate() -> void:
	if !_is_active: 
		show()
		_is_active = true

func _deactivate(is_fast:= false) -> void:
	if _is_active or is_fast: 
		hide()
		_is_active = false

func _on_option_pressed() -> void:
	complete.emit()
