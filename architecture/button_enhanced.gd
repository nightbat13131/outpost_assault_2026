class_name ButtonEnhanced extends Button

enum ButtonStates {Active = 0, # Inactive = 1, 
	Inactive_Hidden = 2, Active_Overwrite = 3}

static var standard_cursor : CustomCursor = load("uid://cb44gaxpio06i")
static var button_cursor : CustomCursor = load("uid://cq7yoy3jauvdv")
@export var active_cursor_overwrite: CustomCursor
@export var initial_state := ButtonStates.Active

func _ready() -> void:
	pressed.connect(_on_pressed)
	set_state(initial_state)

func set_state(state: ButtonStates) -> void:
	match state:
		ButtonStates.Active:
			set_disabled(false)
			show()
			set_mouse_filter(Control.MOUSE_FILTER_STOP)
			
			button_cursor.apply_to_control(self)
		ButtonStates.Active_Overwrite:
			set_disabled(false)
			show()
			set_mouse_filter(Control.MOUSE_FILTER_STOP)
			
			if active_cursor_overwrite:
				active_cursor_overwrite.apply_to_control(self)
			else: 
				print(self, "missing Overwrite cursor")
				button_cursor.apply_to_control(self)
		_:
			set_disabled(true)
			set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
			hide()
			standard_cursor.apply_to_control(self)

func _on_pressed() -> void: pass
