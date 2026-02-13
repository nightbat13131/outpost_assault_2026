class_name HolderCostButtons extends GridContainer

func get_buttons(count: int) -> Array[CostButton]: 
	## assumes all children are CostButton
	var out : Array[CostButton]
	if count > get_child_count():
		_add_buttons(count - get_child_count())
	var index := 0
	for each_button : CostButton in get_children():
		if index < count:
			out.append(each_button)
		else: 
			each_button.deactivate()
		index += 1
	return out

func _add_buttons(count: int) -> void:
	## TODO test this
	var new_ : CostButton
	for i in range(count):
		new_ = load(CostButton.SCENE_PATH).instantiate()
		add_child(new_)

func disable() -> void:
	for each_child: CostButton in get_children():
		each_child.deactivate()
