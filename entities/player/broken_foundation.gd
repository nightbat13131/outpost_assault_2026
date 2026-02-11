class_name BrokenFoundation extends Sprite2D

const SCENE_PATH = ""
var _button: Button_Trigger_UI
var _display_info: DisplayHelper

func _ready() -> void:
	for each_child in get_children():
		if each_child is Button_Trigger_UI:
			_button = each_child
			_display_info = DisplayHelper.new(self, null)
			var size := get_texture().get_size() * .9
			_button.set_size(size)
			_button.set_position(size*-.5)
			_button.set_display_info(_display_info)
			break

func get_display_info() -> DisplayHelper: return _display_info

func _request_build() -> void:
	# TODO check if can purchase
	pass

func _do_repair() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _repair_fail() -> void:
	# warning blink?
	pass
