class_name DialogGroup extends Resource

@export var _dialogs: Array[DialogInfo]

var _index := 0

func get_dialog_info() -> DialogInfo:
	if _index >= _dialogs.size():
		return null
	_index += 1
	return _dialogs[_index-1]
