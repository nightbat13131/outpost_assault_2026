class_name UpgradeVisualizer2D extends UpgradeVisualizer

@export var nodes : Dictionary[FoundationUpgrades.UpgradeTypes, Sprite2D]

func _on_upgrade_changed() -> void:
	var ratio = 0.0
	var sprite: Sprite2D
	for upgrade : FoundationUpgrades.UpgradeTypes in nodes.keys():
		sprite = nodes.get(upgrade, null)
		if sprite:
			if _upgrades:
				ratio =  _upgrades.get_upgrade_ratio(upgrade)
			sprite.modulate.a = ratio
