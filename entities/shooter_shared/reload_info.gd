class_name ReloadInfo extends Resource
## when firing, the bar goes down a % for the clip value instead of down to 0 right away? 

signal state_update(event: String)

const RELOAD_RATE_DECRESE =-.05 # %
const H_SV_GREEN = 110
const SMALLEST_SPEED = 0.05

## Shooter that is using the Reload Info
#var _shooter : Shooter

## Base speed for how long reloadding a full clip takes
@export var _clip_reload_base : float = 0.1

## Base count of ammo in a clip / number of shots in a burst 
@export var _clip_ammo_size_base : int = 1
## Shots fired from current clip
var _clip_ammo_used: int = 0

## Base time between shots within a burst/ clip
@export var _burst_delay_seconds_base : float = 0.03

## How many clips of ammo one starts with - Walking units only have so many bullets. -1 = infinity 
## Decrese when clip is EMPTY
@export var _clip_count : int = -1 

## we wait for the full clip to reload,
## or the delay between firing within a burst 
var _fire_rate_timer_remaining : float = 0.0
var _is_fire_timer_running := true

## called by the shooter since Resources don't process
func process(delta_moded: float) -> void: 
	if delta_moded <= 0.0:
		return
	if _is_fire_timer_running:
		_fire_rate_timer_remaining -= delta_moded
		changed.emit()
		if _fire_rate_timer_remaining <= 0:
			#can_shoot = true
			_is_fire_timer_running = false
			state_update.emit(Shooter.EVENT_HAS_AMMO)

## Overwrite these methods to have the values effect by an upgrade
#region Upgradables

func get_clip_ammo_size() -> int: return _clip_ammo_size_base

func get_burst_delay_seconds() -> float: return max(_burst_delay_seconds_base, 0.05) ## Protect against too small speeds

func get_clip_reload_seconds() -> float: return max(_clip_reload_base, 0.05) ## Protect against too small speeds

#endregion

func can_shoot() -> bool: 
	return !_is_fire_timer_running and _clip_count != 0 # -1 = infiniate

## How many shots are left in the current clip
func get_clip_ammmo_remaining() -> int: return get_clip_ammo_size() - _clip_ammo_used

func get_fire_rate_ratio() -> float:
	return  1.0 - (_fire_rate_timer_remaining / get_clip_reload_seconds())

func get_ui_color() -> Color:
	## HSV Red = 0, green = 110, but .from_HSE() uses percents
	var ratio = get_fire_rate_ratio()
	if _clip_ammo_used != 0: # currently empting the clip
		ratio = 1.0
	return Color.from_hsv( (ratio * H_SV_GREEN) / 360.0, 1, 1)

func get_ratio_clipped_reload() -> float: 
	if _clip_count == 0: # empty or dead:
		return 0.0
	if _clip_ammo_used != 0: # currently empting the clip
		return get_clip_ammmo_remaining() / float(get_clip_ammo_size())
	#wiating for full reload:
	return get_fire_rate_ratio()

func shots_fired(shots_fired_ : int = 1) -> void:
	#print_debug(self)
	_clip_ammo_used += shots_fired_
	if get_clip_ammmo_remaining() <= 0: # reload clip
		_fire_rate_timer_remaining = get_clip_reload_seconds()
		_clip_ammo_used = 0
		if _clip_count > 0:
			_clip_count -= 1
	else: # wait for next bullet in clip/burst
		_fire_rate_timer_remaining = get_burst_delay_seconds()
	_is_fire_timer_running = true
	changed.emit()
	state_update.emit(Shooter.EVENT_JUST_SHOT)

func die():
	_clip_count = 0
	_is_fire_timer_running = false
	changed.emit()
