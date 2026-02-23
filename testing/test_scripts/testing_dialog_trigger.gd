extends ButtonEnhanced

@export var dialog_group : DialogGroup

func _ready() -> void:
	super._ready()

func _on_pressed() -> void: DisplayDialog.set_dialog_group(dialog_group)
