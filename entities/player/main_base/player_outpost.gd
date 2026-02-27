class_name PlayerOutpost extends Building

static var _instatnce : PlayerOutpost

var upgrade_manager: PurchaseManager

func _ready() -> void:
	super._ready()
	_instatnce = self
	set_collision_layer_value(RadarSensor.COLLISION_PLAYER_BUILDING, true)
	_finish_setup.call_deferred()

func _finish_setup() -> void: DisplayPlayerBase.connect_base(self)

func _setup_display_info() -> void:
	_display_info = DisplayHelper.new(self, null, null, null)

func _die() -> void:
	if _instatnce == self:
		_instatnce = null
	super._die()

static func get_instance() -> PlayerOutpost: return _instatnce
