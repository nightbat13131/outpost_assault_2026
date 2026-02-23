class_name DialogInfo extends Resource
# http://www.zombieipsum.com/

@export var _character: Character
@export_multiline var _dialog: String
@export var _special_icon : Texture2D

func get_photo() -> Texture2D: return _character.get_photo()

func get_dialog() -> String: return _dialog

func has_speical() -> bool: return !_special_icon == null

func get_special_icon() -> Texture2D: return _special_icon

func has_dialog() -> bool: return _dialog.length() > 0
