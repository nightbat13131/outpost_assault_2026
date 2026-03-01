class_name DisplayWaveUI extends Control

@onready var wave_number_label: Label = %WaveNumber
@onready var building_ratio_label: Label = %BuildingRatio
@onready var mod_ratio: Label = %ModRatio

static var _instance : DisplayWaveUI

func _ready() -> void:
	_instance = self

func _connect_spawn_manager(node: SpawnManager) -> void:
	node.wave_start.connect(_on_wave_start)

func _on_wave_start(wave_number: int, building_count: int) -> void:
	wave_number_label.set_text(str(wave_number))
	building_ratio_label.set_text("?/"+ str(building_count))

static func get_instance() -> DisplayWaveUI:
	return _instance

static func connect_spawn_manager(node: SpawnManager) -> void:
	if get_instance():
		get_instance()._connect_spawn_manager(node)
	else:
		push_warning("NO DisplayWaveUI for connect_spawn_manager")
