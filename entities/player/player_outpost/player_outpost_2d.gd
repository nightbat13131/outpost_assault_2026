class_name PlayerOutpost2D extends Building2D

static var _instatnce : PlayerOutpost2D

var upgrade_manager: PurchaseManager
@onready var enemy_detector: Area2D = %EnemyDetector

func _ready() -> void:
	super._ready()
	_instatnce = self
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)
	set_collision_mask_value(RadarSensor.COLLISION_ENEMY_HUMANS, true)
	enemy_detector.body_entered.connect(_on_body_entered)
	_finish_setup.call_deferred()

func _finish_setup() -> void: 
	#DisplayPlayerBase.connect_base(self)
	%DetectorCollisionShape2D.set_shape(%CollisionShape2D.get_shape())

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, null, null, null)

func _die() -> void:
	if _instatnce == self:
		_instatnce = null
	super._die()

func _on_body_entered(body: Node2D) -> void:
	if body is EnemyUnit:
		body.on_outpost_entered(self)

static func get_instance() -> PlayerOutpost2D: return _instatnce
