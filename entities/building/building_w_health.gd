class_name Building_w_Health extends Building

@export var _max_hp:= 100.0

func _ready() -> void:
	super._ready()
	if get_health_ui():
		if _max_hp > 0:
			var health_info = HealthInfo.new()
			health_info.set_max_health(_max_hp, true)
			set_health_info(health_info)
