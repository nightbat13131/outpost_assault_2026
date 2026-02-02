@tool
class_name NavPointWeight extends Resource

@export_node_path("NavPoint") var point_path : NodePath: 
	set(value):
		point_path = value
		if _parent:
			_parent.queue_redraw()
@export_range(0,100,1) var weight: = 1.0

var _nav_point : NavPoint
var _parent : Node2D

func set_parent(node: Node2D) -> void: _parent = node

func get_nav_point() -> NavPoint:
	if !_nav_point:
		if _parent:
			if point_path:
				_nav_point = _parent.get_node(point_path)
	return _nav_point

func get_weight() -> float: return weight
