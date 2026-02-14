class_name UpgradeVisualizer extends Sprite2D

@export var _upgrade_type: FoundationUpgrades.UpgradeTypes

var _upgrades: FoundationUpgrades

func _ready() -> void:
	_on_upgrade_changed()

func set_upgrade_info(info: FoundationUpgrades) -> void: 
	_upgrades = info
	_upgrades.upgrade_change.connect(_on_upgrade_changed)
	_on_upgrade_changed() ## apply starting upgrades

func _on_upgrade_changed() -> void:
	var alpha = 0.0
	if _upgrades:
		alpha =  _upgrades.get_upgrade_ratio(_upgrade_type)
	modulate.a = alpha
