extends Node2D

func _ready() -> void:
	var base = PlayerMainBase.get_instance()
	if base:
		base.died.connect(_on_base_death)

func _on_base_death() -> void:
	print("PlayerBase died, Game over.")
