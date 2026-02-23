class_name DialogInfo extends Resource
# http://www.zombieipsum.com/

@export var _character: Character
@export_multiline var _dialog: String
@export var _special_icon : Texture2D
@export_group("Options", "_option") 
@export_multiline var _option_0: String
@export_multiline var _option_1: String
@export_multiline var _option_2: String

func has_speical() -> bool: return !_special_icon == null

func has_dialog() -> bool: return _dialog.length() > 0

func has_choices() -> bool: return _option_0.length() > 0

func get_character() -> Character: return _character

func get_dialog() -> String: return _dialog

func get_special_icon() -> Texture2D: return _special_icon

func get_choices(index: int) -> String: 
	match index: 
		0: 
			return _option_0
		1:
			return _option_1
		2: 
			return _option_2
		_: 
			push_warning("DialogInfo.get_option failed to match index ", index)
			return ""
