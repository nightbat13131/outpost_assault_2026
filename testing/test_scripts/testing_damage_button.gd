extends ButtonEnhanced

const METHOD = "take_damage"

@export var damage_target : Node : get = get_target
@export var damage_amount : float = 10.0

func _ready() -> void:
	super._ready()

func get_target() -> Node2D:
	if damage_target == null:
		push_warning("No damange target set")
		return null
	if damage_target.has_method(METHOD):
		return damage_target
	for each_child in damage_target.get_children():
		if each_child.has_method(METHOD):
			#print("updating damange target")
			return each_child
	return null

func _on_pressed() -> void:
	if !damage_target: 
		push_warning("Testing Damange button does not have a damange target.")
		return
	if damage_target.has_method(METHOD):
		damage_target.take_damage(damage_amount)
	else:
		push_warning("Testing Damange button damage target ", damage_target ," does not have 'take_damage' method.")
