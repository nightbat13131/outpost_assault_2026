class_name DisplayDialog extends VBoxContainer

# Dialog
## let text load
### press to load all text now
## wait a time for text to be read ?? show timer??
### press to move forward
# Options
## let text load ((no type writer)
### select one to move forward

static var _instance : DisplayDialog: get = get_instance
static var _current_group : DialogGroup


static func get_instance()-> DisplayDialog: return _instance

static func set_dialog_group(group: DialogGroup) -> void:
	print("Group set")
	# TODO: what if group is already set...
	_current_group = group
	if _instance:
		_instance._start_display()

static func _get_next_dialog_info() -> DialogInfo:
	if _current_group:
		return _current_group.get_dialog_info()
	return null

@onready var _speical_container: DisplayDialogSpecial = %SpeicalContainer
@onready var _primary_container: DisplayDialogPrimary = %PrimaryContainer



var _is_active := true

func _ready() -> void:
	_instance = self
	_primary_container.complete.connect(_on_dialog_complete)

func _start_display() -> void:
	_apply_dialog(_get_next_dialog_info())

func _apply_dialog(info: DialogInfo) -> void:
	_primary_container.set_info(info)
	_speical_container.set_info(info)
	_speical_container.set_info(info)

func _on_dialog_complete() -> void:
	print("C")
	_start_display()
