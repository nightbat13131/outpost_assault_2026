class_name UpgradeVisualizer extends Node2D

@export var nodes : Dictionary[FoundationUpgrades.UpgradeTypes, Sprite2D]

var _upgrades: FoundationUpgrades

func _ready() -> void:
	_on_upgrade_changed()

func set_upgrade_info(info: FoundationUpgrades) -> void: 
	if _upgrades != null:
		_upgrades.changed.disconnect(_on_upgrade_changed)
	_upgrades = info
	_upgrades.changed.connect(_on_upgrade_changed)
	_on_upgrade_changed() ## apply starting upgrades

func _on_upgrade_changed() -> void:
	var ratio = 0.0
	var sprite: Sprite2D
	for upgrade : FoundationUpgrades.UpgradeTypes in nodes.keys():
		sprite = nodes.get(upgrade, null)
		if sprite:
			if _upgrades:
				ratio =  _upgrades.get_upgrade_ratio(upgrade)
			sprite.modulate.a = ratio
