class_name ClipReloadUI extends PanelContainer

@onready var bar: ProgressBar = %Bar

var _reload_info : ReloadInfo

func set_reload_info(info: ReloadInfo) -> void:
	_disconect()
	_reload_info = info
	if _reload_info:
		_reload_info.changed.connect(_on_reload_change)
		show()
	else:
		hide()

func _on_reload_change() -> void:
	bar.set_as_ratio(_reload_info.get_ratio_clipped_reload())
	bar.set_self_modulate(_reload_info.get_ui_color())

func _disconect() -> void:
	if _reload_info:
		_reload_info.changed.disconnect(_on_reload_change)
		_reload_info = null
