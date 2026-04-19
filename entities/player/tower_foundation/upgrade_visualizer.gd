class_name UpgradeVisualizer extends Node

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
	pass
