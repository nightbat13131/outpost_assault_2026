extends Button

@export var _real : TileMapLogicLayer
@export var _over : TileMapLayer

func _ready() -> void:
	if !(_real and _over):
		return # not set
	if _real.get_tile_set() != _over.get_tile_set():
		return # no match
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# take the tiles used in _over and set them in _real
	var atlas : Vector2i
	for target_cell in _over.get_used_cells():
		atlas = _over.get_cell_atlas_coords(target_cell)
		_real.set_cell(target_cell, 0, atlas)
		_over.set_cell(target_cell)
