class_name DisplayDialogPrimary extends PanelContainer
#TODO animate dialog display frames

signal complete

@onready var dialog_text: DialogTextBox = %DialogText
@onready var choices_holder: DisplayDialogOptions = %ChoicesHolder
@onready var show_character: DisplayCharacter = %ShowCharacter


var _is_active := false
var _waiting_on_dialog := false
var _waiting_on_choices := false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	dialog_text.complete.connect(_on_dialog_complete)
	choices_holder.complete.connect(_on_choices_complete)
	_deactivate(true)

func set_info(info: DialogInfo) -> void: 
	if info:
		_activate()
		_waiting_on_dialog = info.has_dialog()
		_waiting_on_choices = info.has_choices()
		show_character.set_character(info.get_character())
		dialog_text.set_dialog(info.get_dialog())
		choices_holder.set_info(info)
	else:
		_deactivate()

func _activate() -> void:
	show()
	if !_is_active: 
		_is_active = true

func _deactivate(is_fast:= false) -> void:
	show_character.set_character(null)
	dialog_text.set_dialog("")
	hide()
	if _is_active or is_fast: 
		_is_active = false

func on_press() -> void: dialog_text.on_press()

func _on_dialog_complete() -> void:
	_waiting_on_dialog = false
	show_character.talk_end()
	if !_waiting_on_choices:
		complete.emit()

func _on_choices_complete() -> void:
	_waiting_on_choices = false
	if !_waiting_on_dialog:
		complete.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			on_press()
