class_name RadarPreview extends Node2D

# regardless of current tower -- Working
## on purchase tower mouse over:
### over: show_new
### missing: hide_new

# if has tower -- Working
## on foundation mouse over and foundation select:
### over: show_current
### missing: hide_current

# if has tower -- working
## on radar upgrade mouse over
### over: show_next
### missing: hide_next
# what is needed: 
# Button hover, 
# What the tower is (by extention it's radar shape)
## radar's upgraded size
# radar_preview 

# foundation can be gotten from the upgrade..
# foundation can give radar preview the tower_info
# foundation could call the set_preview...

var _tower_info : TowerInfo
var _upgrades : FoundationUpgrades
var _preview_on := false
var _upgrade_preview := false

func set_foundation_upgrades(upgrades: FoundationUpgrades) -> void: _upgrades = upgrades

func set_preview(tower_info : TowerInfo, upgraded: bool = false) -> void:
	queue_redraw()
	_preview_on = tower_info != null
	if _preview_on:
		if tower_info.get_radar_shape():
			_upgrade_preview = upgraded
			_tower_info = tower_info
			_tower_info.set_upgrade_info(_upgrades)
		else:
			_preview_on = false
			_upgrade_preview = false

func get_radar_shape() -> RadarShapeInfo: 
	if _tower_info:
		return _tower_info.get_radar_shape()
	return null

func cancle_preview() -> void: 
	_preview_on = false
	_upgrade_preview = false
	queue_redraw()

func _draw() -> void:
	if !_preview_on:
		return
	if _upgrade_preview:
		var upgraded_shape := _get_temp_upgrade_shape()
		upgraded_shape.draw(self)
	elif get_radar_shape():
		get_radar_shape().draw(self)

func _get_temp_upgrade_shape() -> RadarShapeInfo:
	if !_tower_info:
		return null
	var real_shape : RadarShapeInfo = _tower_info.get_radar_shape() 
	if !real_shape:
		return null
	var temp_shape := RadarShapeInfo.new()
	real_shape.replicate(temp_shape)
	temp_shape.set_outer_radius(_tower_info.get_upgraded_range())
	return temp_shape

static func draw_filled_circle(node: Node2D, radius: float) -> void:
	node.draw_circle(
		Vector2.ZERO,
		radius,
		Utilities.COLOR_RADAR_PREVIEW, 
		false, 
		3
	)
