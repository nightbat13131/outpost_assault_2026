extends Node

@export var _cursors : Array[CustomCursor]

func _ready() -> void:
	for each in _cursors:
		each.activate()
