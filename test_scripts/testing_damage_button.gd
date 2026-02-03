extends Button

@export var damage_target : Node2D
@export var damage_amount : float = 10.0

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	if damage_target.has_method("take_damage"):
		damage_target.take_damage(damage_amount)
	else:
		push_warning("Testing Damange button damage target ", damage_target ," does not have 'take_damage' method.")
