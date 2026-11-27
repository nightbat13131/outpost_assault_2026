extends ButtonEnhanced

#@export var node: Node2D
@export var holder : TowerHolder

var current_index := 0

func _on_pressed() -> void:
	if holder:
		if current_index > holder.get_child_count() -1:
			current_index = 0
		var node : Node2D = holder.get_child(current_index)
		var pos = node.global_position
		prints("node", node, "is in the map: ", FogOfWar.is_within_game_view(pos), ". POS: ", pos, " Index: ", current_index)
		current_index += 1
