extends TestZone

@export var damage := 30.0

func _ready() -> void:
	super._ready()
	color = Color.GREEN_YELLOW

func _effect_enemy(body: EnemyUnit) -> void:
	if body.take_damage(damage):
		pass
