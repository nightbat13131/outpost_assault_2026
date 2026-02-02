class_name SpawnManager extends Node2D

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	for each_child in get_children():
		if each_child is Spawner:
			each_child.set_unit_container(self)
			each_child.start_wave(1) # debug


func _on_child_entered_tree(node: Node) -> void:
	print(node)
