class_name DialogTextBox extends RichTextLabel

signal complete

const SHOW_CHAR_SPEED := 50.0 # how many characters per second
const WAIT_SCALE := .5

var _is_waiting := false
@onready var wait_timer: Timer = %WaitTimer
@export var show_character: DisplayCharacter

func _ready() -> void:
	wait_timer.timeout.connect(_on_wait_timeout)

func set_dialog(dialog: String) -> void:
	set_text(dialog)
	if dialog.length() > 0:
		if show_character:
			show_character.talk_start()
	set_visible_ratio(0.0) # set_visible_characters(0) was working, but stopped changing ratio for animation

func _get_wait_time() -> float:
	#TODO let dialog speed be a setting user can speed up or slow down
	return WAIT_SCALE * SHOW_CHAR_SPEED /get_text().length()

func _get_char_speed_ratio() -> float:
	#TODO let dialog speed be a setting user can speed up or slow down
	if get_text().length() > 0:
		return SHOW_CHAR_SPEED /get_text().length()
	return 0.0

func _process(delta: float) -> void:
	if get_visible_ratio() < 1.0:
		visible_ratio += _get_char_speed_ratio() * delta
		if visible_ratio >= 1.0:
			_start_wait()

func _start_wait() -> void:
	_is_waiting = true
	if show_character:
		show_character.talk_end()
	wait_timer.start(_get_wait_time())

func on_press() -> void:
	if get_visible_ratio() < 1.0:
		set_visible_ratio(1.0)
		_start_wait()
	elif _is_waiting:
		_on_wait_timeout()

func _on_wait_timeout() -> void:
	wait_timer.stop() # for when manualy triggered
	_is_waiting = false
	complete.emit()
