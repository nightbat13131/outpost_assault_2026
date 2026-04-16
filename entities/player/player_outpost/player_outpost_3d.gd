class_name PlayerOutpost3D extends Building3D

static var _instatnce : PlayerOutpost3D

var upgrade_manager: PurchaseManager
@onready var enemy_detector: Area3D = %EnemyDetector

func _ready() -> void:
	super._ready()
	_instatnce = self
	tree_exiting.connect(_die)
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)
	set_collision_mask_value(RadarSensor.COLLISION_ENEMY_HUMANS, true)
	enemy_detector.body_entered.connect(_on_body_entered)
	_finish_setup.call_deferred()

static func get_instance() -> PlayerOutpost3D: return _instatnce

func _die() -> void:
	if _instatnce == self:
		_instatnce = null
	super._die()

func _finish_setup() -> void: 
	DisplayPlayerBase.connect_base(self)
	# %DetectorCollisionShape2D.set_shape(%CollisionShape2D.get_shape()) do I need to make it unique? 

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, null, null, null)


func _on_body_entered(body: Node3D) -> void:
	if body: # is EnemyUnit: ## TODO: 3d version 
		if body.has_method('on_outpost_entered'):
			body.on_outpost_entered(self)
