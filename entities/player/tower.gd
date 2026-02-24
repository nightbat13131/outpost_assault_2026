class_name Tower extends Area2D

signal dead(tower: Tower) ## I don't think the foundation cares between sold and destroyed.
signal health_changed

var _my_type := TowerInfo.TowerType.NA
var _max_hp :  float = 100
var _hp : float = 100: set = set_health
var _health_ui : HealthUI
var _radar_sensor : RadarSensor

@onready var _tower_purchase_manager: PurchaseManager_GunNest = %TowerPurchaseManager
@onready var _context_manager: TowerContextManager = %TowerContextManager
var _founation_upgrades : FoundationUpgrades
@onready var _shooter: Shooter

func _ready() -> void:
	_mid_ready()
	set_max_health(TowerInfo.get_max_health(_my_type), true)
	_tower_purchase_manager.set_foundation(get_foundation())
	_context_manager.set_tower(self)
	for each_child in get_children(): # so that no every tower HAS to have a shooter
		if each_child is Shooter: 
			_shooter = each_child
			_radar_sensor = _shooter.get_radar_sensor()

func _mid_ready() -> void: 
	push_error(self, " Needs to overwrite Tower._mid_ready()")

func setup(upgrades: FoundationUpgrades, health_ui: HealthUI, clip_reload_ui: ClipReloadUI) -> void:
	_founation_upgrades = upgrades
	_founation_upgrades.changed.connect(_on_upgrade_changed)
	_on_upgrade_changed.call_deferred()
	_health_ui = health_ui
	if _health_ui:
		_hp = _hp
	await ready
	if _shooter:
		_shooter.set_foundation_upgrades(_founation_upgrades)
	clip_reload_ui.set_reload_info(get_reload_info())

func _set_radar_range() -> void:
	var _range = TowerInfo.get_radar_range(_my_type, _founation_upgrades)
	if _shooter:
		_shooter._set_range(_range)

func repair() -> void: set_health(_max_hp)

func get_repair_cost() -> float: return (1- get_health_ratio()) * TowerInfo.get_tower_cost(_my_type)

func set_max_health(max_hp: float, force_full:= false) -> void:
	if max_hp <= 0.0: 
		push_error(self, "Max health getting pushed a bad number ", max_hp)
		return
	_max_hp = max_hp
	if force_full:
		_hp = _max_hp
	else:
		_hp = _hp

func set_health(hp: float) -> void:
	_hp = hp
	health_changed.emit()
	if _health_ui:
		_health_ui.set_health_ratio(get_health_ratio())
	if _hp <= 0:
		_die()

func take_damage(damage_delt: float) -> void: _hp -= abs(damage_delt)

func get_health_ratio() -> float: return clamp(_hp / _max_hp, 0.0, 1.0)

func get_health_ui() -> HealthUI: return _health_ui

func get_reload_info() -> ReloadInfo:
	if _shooter:
		return _shooter.get_reload_info()
	return null

func _on_upgrade_changed() -> void:
	_set_radar_range()

func sell() -> void:
	GoldManager.earn_gold(get_sell_value())
	dead.emit(self)
	queue_free()

func get_sell_value() -> float: return get_health_ratio() * TowerInfo.get_tower_cost(_my_type)

func get_foundation() -> TowerFoundation: 
	if _founation_upgrades:
		return _founation_upgrades.get_foundation()
	return null

func being_replaced() -> void: queue_free()

func _die() -> void:
	#TODO : Explode
	queue_free()
	dead.emit(self)

func get_purchase_manager() -> PurchaseManager: return _tower_purchase_manager

func get_context_manager() -> TowerContextManager: return _context_manager

static func get_scene_path() -> String: return "Method needs overriting missing"
