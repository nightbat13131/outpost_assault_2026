class_name Button_Trigger_UI extends ButtonEnhanced

signal selected

func _on_pressed() -> void: selected.emit()
