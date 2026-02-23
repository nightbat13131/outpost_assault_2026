class_name DisplayDialogSpecial extends PanelContainer


@onready var special_icon: TextureRect = %SpecialIcon

var _is_active := true

func _ready() -> void:
	_deactivate(true)

func set_info(info: DialogInfo) -> void: 
	if info:
		if info.has_speical():
			_activate()
			special_icon.set_texture(info.get_special_icon())
			return
	_deactivate()

func _activate() -> void:
	if !_is_active: 
		show()
		_is_active = true

func _deactivate(is_fast:= false) -> void:
	if _is_active or is_fast: 
		special_icon.set_texture(null)
		hide()
		_is_active = false
