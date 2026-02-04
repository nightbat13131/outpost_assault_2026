extends TestZone

func _ready() -> void:
	super._ready()
	color = Color.SADDLE_BROWN

func _effect_enemy(body: EnemyUnit) -> void:
		body._die()
