class_name BrokenFoundation extends Sprite2D

const SCENE_PATH = ""

@onready var button: Button = %Button

func _ready() -> void:
	var size := get_texture().get_size() * .9
	button.set_size(size)
	button.set_position(size*-.5)

func _request_build() -> void:
	# TODO check if can purchase
	pass

func _do_repair() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _repair_fail() -> void:
	# warning blink?
	pass
