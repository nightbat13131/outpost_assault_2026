@tool
class_name ShooterAtomicState extends AtomicState

var _radar : RadarSensor: set = set_radar_sensor, get = get_radar_sensor
var _shooter : Shooter: set = set_shooter, get = get_shooter

func _ready() -> void:
	super._ready()

func set_radar_sensor(radar: RadarSensor) -> void: _radar = radar

func get_radar_sensor() -> RadarSensor: return _radar

func set_shooter(shooter: Shooter) -> void: _shooter = shooter

func get_shooter() -> Shooter: return _shooter

func has_target() -> bool:
	if _radar:
		#print("searching 1")
		return get_radar_sensor().has_target()
	push_warning(self, " radar not found.")
	return false

func send_event(event: String) -> void:
	if _shooter:
		get_shooter().send_event.call_deferred(event)
