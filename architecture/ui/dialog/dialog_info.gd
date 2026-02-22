class_name DialogInfo extends Resource
# http://www.zombieipsum.com/

@export var _character: Character
@export_multiline var _dialog: String
@export var _special_icon : Texture2D

func get_photo() -> Texture2D: return _character.get_photo()

func get_dialog() -> String: return _dialog

func get_special_icon() -> Texture2D: return _special_icon
