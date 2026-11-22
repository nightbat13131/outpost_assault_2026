@tool
extends Node2D

@export var _target_foundation : TowerFoundation2D

@export var _button : ButtonEnhanced

var _old_radian := 1.0
var _used_radian := 0.0
var _in_process_radian := .3

var _is_pressed := false

func _ready() -> void:
	if _button:
		_button.button_down.connect(_on_down)
		_button.button_up.connect(_on_up)
	await get_tree().create_timer(.5).timeout
	set_foundation(_target_foundation)

func set_foundation(node: TowerFoundation2D) -> void:
	_target_foundation = node
	if _target_foundation:
		_old_radian = _target_foundation.get_facing_radian()
		_set_used_radian(_old_radian)
	queue_redraw()

func _set_used_radian(value: float) -> void:
		_used_radian = snappedf(value, TowerFoundation2D.FACING_RADIAN_SNAP)
		get_child(0).rotation = _used_radian

func _on_down() -> void:
	_is_pressed = true

func _on_up() -> void:
	_is_pressed = false
	if _target_foundation:
		_target_foundation.set_facing_radian(_used_radian)

func _process(_delta: float) -> void:
	if _is_pressed and _target_foundation:
		var direction = get_local_mouse_position()
		_in_process_radian = direction.angle()
		_set_used_radian(_in_process_radian)
		#_used_radian = snappedf(_in_process_radian, TowerFoundation2D.FACING_RADIAN_SNAP)
		#get_child(0).rotation = _used_radian
		queue_redraw()

func _draw() -> void:
	draw_line(Vector2.ZERO, Vector2.from_angle(_old_radian) * 75, Color.GRAY, 15)
	draw_line(Vector2.ZERO, Vector2.from_angle(_used_radian) * 60, Color.BLACK, 10)
	draw_line(Vector2.ZERO, Vector2.from_angle(_in_process_radian) * 45, Color.BLUE, 3)
