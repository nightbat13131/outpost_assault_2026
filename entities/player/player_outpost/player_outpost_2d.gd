class_name PlayerOutpost extends Building2D

static var _instance : PlayerOutpost

@onready var _upgrade_manager: PurchaseManager_Outpost = %UpgradeManager
@onready var _enemy_detector: Area2D = %EnemyDetector
@onready var _heal_timer: TimerModded = %HealTimer

var _outpost_upgrades : PlayerOutpostUpgrades : get = get_outpost_upgrades

func _init() -> void:
	_instance = self
	tree_exiting.connect(_on_tree_exiting)

func _ready() -> void:
	super._ready()
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)
	set_collision_mask_value(RadarSensor.COLLISION_ENEMY_HUMANS, true)
	_upgrade_manager.set_upgrade_info(get_outpost_upgrades())
	get_outpost_upgrades().changed.connect(_on_upgrades_changed)
	_enemy_detector.body_entered.connect(_on_body_entered)
	_finish_setup.call_deferred()
	_heal_timer.set_wait_time(1.0)
	_heal_timer.timeout.connect(_on_heal_timout)
	_heal_timer.set_is_repeating(true)

func get_outpost_upgrades() -> PlayerOutpostUpgrades:
	if _outpost_upgrades == null:
		_outpost_upgrades = PlayerOutpostUpgrades.new()
	return _outpost_upgrades

func _finish_setup() -> void: 
	DisplayPlayerBase.connect_base(self)
	%DetectorCollisionShape2D.set_shape(%CollisionShape2D.get_shape())

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, get_health_info(), _upgrade_manager, null)

func _die() -> void:
	if _instance == self:
		_instance = null
	super._die()

func _on_body_entered(body: Node2D) -> void:
	if body is EnemyUnit:
		body.on_outpost_entered(self)

func _on_tree_exiting() -> void:
	_instance = null

func _on_upgrades_changed() -> void:
	var rate := _outpost_upgrades.get_hp_repair_per_second()
	if rate > 0:
		_heal_timer.start()

func _on_heal_timout() -> void:
	if get_health_info().try_heal(get_outpost_upgrades().get_hp_repair_per_second()):
		Utilities.node_flash(self, Color.GREEN)

static func has_instance() -> bool: return _instance != null
 
static func get_instance() -> PlayerOutpost: return _instance

static func get_upgrade_max_mod() -> int:
	if has_instance():
		return get_instance().get_outpost_upgrades().get_max_upgrade_mod()
	return 0

static func get_banking_bonus() -> float:
	if has_instance():
		return get_instance().get_outpost_upgrades().get_banking_bonus()
	return 0
