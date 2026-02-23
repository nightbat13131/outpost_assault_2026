class_name DisplayDialogPrimary extends PanelContainer
#TODO animate dialog display frames

signal complete

@onready var character_photo: DialogPhoto = %CharacterPhoto
@onready var dialog_text: DialogTextBox = %DialogText

@onready var choices_holder: VBoxContainer = %ChoicesHolder

var _is_active := false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	dialog_text.complete.connect(_on_dialog_complete)
	_deactivate(true)

func set_info(info: DialogInfo) -> void: 
	if info:
		_activate()
		character_photo.set_photo(info.get_photo())
		dialog_text.set_dialog(info.get_dialog())
	else:
		_deactivate()

func _activate() -> void:
	if !_is_active: 
		show()
		_is_active = true

func _deactivate(is_fast:= false) -> void:
	character_photo.deactivate()
	if _is_active or is_fast: 
		hide()
		_is_active = false

func on_press() -> void: dialog_text.on_press()

func _on_dialog_complete() -> void: 
	complete.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			on_press()
