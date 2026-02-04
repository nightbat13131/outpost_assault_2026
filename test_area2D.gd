class_name TestZone extends Area2D

@onready var collision_shape_2d: CollisionShape2D 
var color : Color = Color.BISQUE

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	for each_child in get_children():
		if each_child is CollisionShape2D:
			collision_shape_2d = each_child

func _draw() -> void:
	draw_circle(Vector2.ZERO, collision_shape_2d.get_shape().get_radius(), Color(color, .5))

func _on_body_entered(body) -> void: 
	if body is EnemyUnit:
		_effect_enemy(body)

func _effect_enemy(body: EnemyUnit) -> void: pass
