class_name BrokenFoundationSpawner extends Node2D

var _tower_holder : TowerHolder
var _spawn_cords : Array[Vector2]
var _count := 0
var _parent_display_info: DisplayHelper

func _ready() -> void:
	_populate_positions()
	_populat_holder.call_deferred()

func _populat_holder() -> void: _tower_holder = TowerHolder.get_instance()

func activate(parent_display_info: DisplayHelper) -> void: 
	_parent_display_info = parent_display_info
	for each_pos in _spawn_cords: 
		__populate_foundation(each_pos)

func __populate_foundation(global_position_: Vector2) -> void:
	var new_ = load(BrokenFoundation.SCENE_PATH).instantiate()
	## TODO get correct parrent
	new_.set_global_position(global_position_)
	_tower_holder.add_child(new_)
	if _count == 0:
		DisplaySelected.replace_information(_parent_display_info, new_.get_display_info())
		_count += 1

func _populate_positions() -> void:
	for each_child in get_children():
		if each_child is Node2D:
			_spawn_cords.append(each_child.global_position)
	if _spawn_cords.is_empty():
		_spawn_cords.append(global_position)
