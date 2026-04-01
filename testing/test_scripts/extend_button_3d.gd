@tool
extends "res://addons/Button3D_addon/Button3D.gd"

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	prints("B")
