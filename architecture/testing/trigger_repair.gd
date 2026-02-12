extends ButtonEnhanced

@export var target : Node2D


func _on_pressed() -> void:
	if !target: 
		push_warning("Testing _do_repair button does not have a target.")
		return
	if target.has_method("_do_repair"):
		target._do_repair()
	else:
		push_warning("Testing _do_repair button target ", target ," does not have '_do_repair' method.")
