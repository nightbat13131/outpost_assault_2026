class_name DisplayDialog extends VBoxContainer
# TODO: consider dialog history within each level.

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
	# TODO: what if Dialog already qued up, currently replaces. 
	_current_group = group
	if _current_group:
		_current_group.refresh()
	if _instance:
		_instance._display_next()

static func _get_next_dialog_info() -> DialogInfo:
	if _current_group:
		return _current_group.get_dialog_info()
	return null

@onready var _speical_container: DisplayDialogSpecial = %SpeicalContainer
@onready var _primary_container: DisplayDialogPrimary = %PrimaryContainer

func _ready() -> void:
	_instance = self
	_primary_container.complete.connect(_on_dialog_complete)

func _display_next() -> void:
	_apply_dialog(_get_next_dialog_info())

func _apply_dialog(info: DialogInfo) -> void:
	_primary_container.set_info(info)
	_speical_container.set_info(info)
	_speical_container.set_info(info)

func _on_dialog_complete() -> void: _display_next()
