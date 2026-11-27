extends ButtonEnhanced

enum SelectionType {CANCEL = 0, PLAYER_OUTPOST = 1, TOWER_LOWER = 2, TOWER_HIER = 3, CAMERA_SYNC = 4}

@export var selection_type : SelectionType

func _on_pressed() -> void:
	match selection_type:
		SelectionType.PLAYER_OUTPOST:
			PlayerOutpost.remote_select()
		SelectionType.TOWER_LOWER:
			TowerHolder.request_select_child(-1)
		SelectionType.TOWER_HIER:
			TowerHolder.request_select_child(1)
		SelectionType.CAMERA_SYNC:
			CameraBinder.trigger_camera_sync()
		_:
			DisplaySelected.request_display(null)
