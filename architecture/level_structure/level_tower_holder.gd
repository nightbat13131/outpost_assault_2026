class_name TowerHolder extends Node2D

static var _instance : TowerHolder

var _last_index := 0

## because non- tower stuff gets in here like tower projectiles.
var tower_children : Array[Node2D]  = []

func _init() -> void:
	_instance = self
	tree_exiting.connect(_on_exiting_tree)
	child_entered_tree.connect(_on_child_entered_tree)

func _on_exiting_tree() -> void: _instance = null

static func has_instance() -> bool: return _instance != null

static func get_instance() -> TowerHolder: return _instance

func _on_child_selected(node: Node) -> void:
	prints(node, "selected", tower_children.find(node))
	_last_index = tower_children.find(node)

func _on_child_entered_tree(node: Node) -> void:
	if node is Foundation:
		node.selected.connect(_on_child_selected)
		tower_children.append(node)
		node.tree_exiting.connect(_on_tower_child_leaving.bind(node))

func _on_tower_child_leaving(node: Node2D) -> void:
	while tower_children.has(node):
		tower_children.erase(node)

func _request_select_child(direction: int) -> void:
	var child : Foundation
	var limit := 100
	while limit > 0:
		limit -= 1
		_last_index = (_last_index + direction) % tower_children.size()
		child = tower_children[_last_index]
		if FogOfWar.is_within_game_view(child.global_position):
			child.on_selected()
			return
	

static func request_select_child(direction: int) -> void:
	if has_instance():
		get_instance()._request_select_child(direction)
	
