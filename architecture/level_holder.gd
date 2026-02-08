extends SubViewport

func _ready() -> void:
	_show_size()
	size_changed.connect(_show_size)

func _show_size() -> void: print(size)
