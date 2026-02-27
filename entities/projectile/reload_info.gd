class_name ReloadInfo extends Resource
## when firing, the bar goes down a % for the clip value instead of down to 0 right away? 

signal state_update(event: String)

const RELOAD_RATE_DECRESE =-.05 # %

## Shooter that is using the Reload Info
var _shooter : Shooter
## Upgrade reference for the shooter's foundation
var _foundation_upgrades : FoundationUpgrades


## Base speed for how long reloadding a full clip takes
@export var _clip_reload_base : float = 0.1
## How long it takes to reload a full clip with upgrades
var _reload_seconds := 0.5 : set = _set_reload_rate

## Base count of ammo in a clip / number of shots in a burst 
@export var _clip_ammo_size_base : int = 1
## The current max clip size after upgrades, how much ammo used in each burst
var _clip_ammo_size : int
## Shots fired from current clip
var _clip_ammo_used: int = 0

## Base time between shots within a burst/ clip
@export var _burst_delay_seconds_base : float = 0.03
## Time Between shots within in a burst/clip after upgrades
var _burst_delay_seconds : float = 0.03 

## How many clips of ammo one starts with - Walking units only have so many bullets. -1 = infinity 
## Decrese when clip is EMPTY
@export var _clip_count : int = -1 

## we wait for the full clip to reload,
## or the delay between firing within a burst 
var _fire_rate_timer_remaining : float = 0.0
var _is_fire_timer_running := true

func setup(shooter: Shooter, foundation_upgrades: FoundationUpgrades)-> void: #, reload_rate_base: float, clip_size_base: int, burst_rate: float, ammo_count: int) -> void:
	_shooter = shooter
	_foundation_upgrades = foundation_upgrades
	if _foundation_upgrades:
		_foundation_upgrades.changed.connect(_on_upgrade_changed)
	_on_upgrade_changed()

func _on_upgrade_changed() -> void:
	_reload_seconds = _clip_reload_base
	_clip_ammo_size = _clip_ammo_size_base
	_burst_delay_seconds = _burst_delay_seconds_base

func process(delta_moded: float) -> void: # called by the shooter since Resources don't process
	if delta_moded <= 0.0:
		return
	if _is_fire_timer_running:
		_fire_rate_timer_remaining -= delta_moded
		changed.emit()
		if _fire_rate_timer_remaining <= 0:
			#can_shoot = true
			_is_fire_timer_running = false
			state_update.emit(Shooter.EVENT_HAS_AMMO)

func can_shoot() -> bool: 
	return !_is_fire_timer_running and _clip_count != 0 # -1 = infiniate

## How many shots are left in the current clip
func get_clip_ammmo_remaining() -> int: return _clip_ammo_size - _clip_ammo_used

func get_fire_rate_ratio() -> float:
	if _reload_seconds == 0:
		return 1.0
	return  1.0 - (_fire_rate_timer_remaining / _reload_seconds)

func get_ui_ratio() -> float:
	
	return .50

func get_ui_color() -> Color:
	## HSV Red = 0, green = 110, but .from_HSE() uses percents
	var ratio = get_fire_rate_ratio()
	if _clip_ammo_used != 0: # currently empting the clip
		ratio = 1.0
	return Color.from_hsv( (ratio * 110) / 360.0, 1,1,1 )

func get_ratio_clipped_reload() -> float: 
	if _clip_ammo_used != 0: # currently empting the clip
		return get_clip_ammmo_remaining() / float(_clip_ammo_size)
	#wiating for full reload:
	return get_fire_rate_ratio()

func shots_fired(shots_fired_ : int = 1) -> void:
	_clip_ammo_used += shots_fired_
	if get_clip_ammmo_remaining() <= 0: # reload clip
		_fire_rate_timer_remaining = _reload_seconds
		_clip_ammo_used = 0
		if _clip_count > 0:
			_clip_count -= 1
	else: # wait for next bullet in clip/burst
		_fire_rate_timer_remaining = _burst_delay_seconds
	_is_fire_timer_running = true
	changed.emit()
	state_update.emit(Shooter.EVENT_JUST_SHOT)

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

func die():
	_clip_count = 0
	_is_fire_timer_running = false
