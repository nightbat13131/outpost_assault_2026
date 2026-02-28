class_name LevelViewport extends SubViewport

## TODO going to have to remove Level in smarter way

func add_level(level: Level) -> void:
	for old in get_children():
		old.queue_free()
	add_child(level)

func deactivate() -> void:
	for old in get_children():
		old.queue_free()
