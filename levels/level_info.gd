class_name LevelInfo extends Resource

@export var level_name: String: get = get_level_name
@export var level_uid: String : get = get_level_path
@export var starting_gold: float = 1000

@export_category("Towers")
@export var _allow_all_towers := false
@export var _availalbe_towers : Array[TowerInfo_reference.TowerType] = []
@export_category("Outpost")
@export var _allow_all_outpost_upgrades := false
@export var _availalbe_outpost_upgrades : Array[PlayerOutpostUpgrades.UpgradeTypes] = []

@export_category("Dialog")
@export var _dialog_groups: Array[DialogGroup]
@export var _victory_dialog: DialogGroup

func get_level_name() -> String:
	if level_name:
		return level_name
	return "Nameless Level"

func get_level_path() -> String: return level_uid

func on_level_start() -> void: 
	GoldManager.on_level_start(starting_gold)

func get_dialog_group(index: int) -> DialogGroup:
	if index >= _dialog_groups.size():
		push_warning(self, "send_dialog_group index out of bounds. index: ", index, " size: ", _dialog_groups.size())
		return null
	return _dialog_groups[index]

func get_victory_dialog() -> DialogGroup: return _victory_dialog

func is_tower_available(tower: TowerInfo_reference.TowerType) -> bool: 
	if _allow_all_towers:
		return true
	return _availalbe_towers.has(tower)

func is_player_outpost_upgrade_available(upgrade: PlayerOutpostUpgrades.UpgradeTypes) -> bool: 
	if _allow_all_outpost_upgrades:
		return true
	return _availalbe_outpost_upgrades.has(upgrade)
