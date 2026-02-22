class_name DisplayDialog extends VBoxContainer

static var _instance : DisplayDialog
static var _queue : Array
@onready var special_icon: TextureRect = %SpecialIcon 
@onready var character_photo: TextureRect = %CharacterPhoto
@onready var dialog_text: RichTextLabel = %DialogText
@onready var choices_holder: VBoxContainer = %ChoicesHolder

func _ready() -> void:
	_instance = self




static func get_instance()-> DisplayDialog:
	return _instance
