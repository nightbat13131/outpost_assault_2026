class_name ReloadInfo extends Resource
## when firing, the bar goes down a % for the clip value instead of down to 0 right away? 
signal values_changed
signal maxes_changed

const RELOAD_RATE_DECRESE =-.05 # %

## Shooter that is using the Reload Info
var _shooter : Shooter
## Upgrade reference for the shooter's foundation
var _foundation_upgrades : FoundationUpgrades



## Base speed for how long reloadding a full clip takes
@export var _clip_reload_base : float = 0.1
## How long it takes to reload a full clip with upgrades
var _reload_seconds := 0.0 : set = _set_reload_rate

## Base count of ammo in a clip / number of shots in a burst 
@export var _clip_size_base : int = 1
## The current max clip size after upgrades, how much ammo used in each burst
var _clip_size : int
## Shots fired from current clip
var _clip_ammo_used: int = 0

## Base time between shots within a burst/ clip
@export var _burst_delay_seconds_base : float = 0.03
## Time Between shots within in a burst/clip after upgrades
var _burst_delay_seconds : float = 0.03 

## How many clips of ammo one starts with - Walking units only have so many bullets. -1 = infinity 
## Decrese when clip is EMPTY
var _clip_count : int = -1 

var on_clip_cooldown := false

## we wait for the full clip to reload,
## or the delay between firing within a burst 
var _fire_rate_timer_remaining : float = 0.0
var _is_fire_timer_running := true

func setup(shooter: Shooter, foundation_upgrades: FoundationUpgrades)-> void: #, reload_rate_base: float, clip_size_base: int, burst_rate: float, ammo_count: int) -> void:
	_shooter = shooter
	_foundation_upgrades = foundation_upgrades
	#_reload_seconds_base = reload_rate_base
	#_reload_seconds = _reload_seconds_base
	#_clip_size_base = _clip_size_base
	#_clip_size = clip_size_base
	#_burst_delay_seconds_base = burst_rate
	#_burst_delay_seconds = _burst_delay_seconds_base
	#_ammo_count = ammo_count

func process(delta_moded: float) -> void: # called by the shooter since Resources don't process
	if delta_moded <= 0.0:
		return
	if _is_fire_timer_running:
		_fire_rate_timer_remaining -= delta_moded
		values_changed.emit()
		if _fire_rate_timer_remaining <= 0:
			#can_shoot = true
			_is_fire_timer_running = false

func is_disabled() -> bool:	return _clip_count == 0 # -1 = infiniate

func can_shoot() -> bool: return _fire_rate_timer_remaining <= 0 and !is_disabled()

func get_clip_max_size() -> int: return _clip_size

func get_clip_ammmo_count() -> int: return _clip_size - _clip_ammo_used

func get_fire_rate_ratio() -> float:
	if _reload_seconds == 0:
		return 1.0
	return  1.0 - (_fire_rate_timer_remaining / _reload_seconds)

func get_color_clipped_reload() -> Color:
	
	## HSV Red = 0, green = 110, but .from_HSE() uses percents
	var ratio = get_fire_rate_ratio()
	if _clip_ammo_used != 0: # currently empting the clip
		ratio = 1.0
	return Color.from_hsv( (ratio * 110) / 360.0, 1,1,1 )

func get_ratio_clipped_reload() -> float: 
	if _clip_ammo_used != 0: # currently empting the clip
		return get_clip_ammmo_count() / float(get_clip_max_size())
	#wiating for full reload:
	return get_fire_rate_ratio()

func shots_fired(shots_fired_ : int = 1) -> void:
	_calculate_clip_and_reload(shots_fired_)

func set_foundation_upgrades(foundation_upgrads: FoundationUpgrades) -> void:
	_foundation_upgrades = foundation_upgrads

#func upgrade_cooling(rank: int):
	#match _tower_type:
		#Global.Tower_Types.gatling:
			#_clip_size = _clip_size_base + rank
		#Global.Tower_Types.missile:
			#if rank < 4:
				#_clip_size = min(_clip_size_base + rank, 4)
		#Global.Tower_Types.cannon:
			#pass
	#_reload_seconds = _reload_seconds_base * (1+(rank*(rank*.5)*RELOAD_RATE_DECRESE))
	#maxes_changed.emit()
#
#func upgrade_gearbox(rank):
	#_burst_delay_seconds = max (0.05, # protect aginst too fast timer
		#_burst_delay_seconds_base * (1-(rank*rank* Shooter.ROT_EXPAND))
	#)

func _set_reload_rate(value): _reload_seconds = max(value, 0.05) ## protect againt number too low for timing to work 

func _calculate_clip_and_reload(shots_fired_ : int = 1):
	_clip_ammo_used += shots_fired_
	if _clip_ammo_used >= _clip_size: # reload
		_fire_rate_timer_remaining = _reload_seconds
		_clip_ammo_used = 0
	else:
		_fire_rate_timer_remaining = _burst_delay_seconds
	_is_fire_timer_running = true
	values_changed.emit()

func die():
	_clip_count = 0
	_is_fire_timer_running = false
