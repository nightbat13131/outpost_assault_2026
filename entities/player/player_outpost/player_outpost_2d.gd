class_name PlayerOutpost extends Building2D


static var _instatnce : PlayerOutpost

@onready var _upgrade_manager: PurchaseManager_Outpost = %UpgradeManager
@onready var _enemy_detector: Area2D = %EnemyDetector
var _outpost_upgrades : PlayerOutpostUpgrades

func _ready() -> void:
	super._ready()
	_instatnce = self
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)
	set_collision_mask_value(RadarSensor.COLLISION_ENEMY_HUMANS, true)
	if _outpost_upgrades == null:
		_outpost_upgrades = PlayerOutpostUpgrades.new()
	_upgrade_manager.set_upgrade_info(_outpost_upgrades)
	_enemy_detector.body_entered.connect(_on_body_entered)
	_finish_setup.call_deferred()

func _finish_setup() -> void: 
	DisplayPlayerBase.connect_base(self)
	%DetectorCollisionShape2D.set_shape(%CollisionShape2D.get_shape())

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, get_health_info(), _upgrade_manager, null)

func _die() -> void:
	if _instatnce == self:
		_instatnce = null
	super._die()

func _on_body_entered(body: Node2D) -> void:
	if body is EnemyUnit:
		body.on_outpost_entered(self)

static func get_instance() -> PlayerOutpost: return _instatnce
