@tool
class_name NavPoint3D extends RayCast3D

const DEBUGING = true
const DEBUG_SHIFT = 2.0

const DEFAULT_DESIRED_DISTANCE := 1.0

## NavigationLinks MIGHT serve this purpose, but I like the controle I have so far...
## Helper class to manually guide NavigationAgent3D

#@export var next_target_weights: Dictionary[NavPoint, int] # started crashing the engine after about 30 minutes
## Paths for next nav points and their weights. 
#@export var next_target_weights: Array[NavPointWeight] = []
#@onready var _picker: WeightedPicker

## If I really want weighted splits between next target, I can add it mulitple times. 
@export var next_targets : Array[NavPoint3D]
## For disabling the nav point when it has to be on screen but not being used. 
@export var is_disabled := false
## The distance threshold before the target is considered to be reached.
@export var target_distance := DEFAULT_DESIRED_DISTANCE :
	set(value):
		target_distance = abs(value)
		#queue_redraw()

func _ready() -> void:
	if is_disabled:
		if Engine.is_editor_hint():
			return
		#queue_free()
		return
	prune_targets()
	set_collision_mask(RadarSensor.COLLISION_GROUND)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or DEBUGING:
		var s_xf: Transform3D = global_transform
		#DebugDraw3D.draw_sphere(s_xf.origin, target_distance, Color.BLUE_VIOLET)
		#DebugDraw3D.draw_cylinder(s_xf, Color.BLUE_VIOLET, 0.0)
		DebugDraw3D.draw_cylinder_ab(
			Vector3(s_xf.origin)
			,Vector3(s_xf.origin.x, s_xf.origin.y + DEBUG_SHIFT, s_xf.origin.z)
			, target_distance
			, Color.BLUE_VIOLET
		)
		var line_start := global_position
		#line_start.y += DEBUG_SHIFT
		var line_target : Vector3
		for each_navpoint in next_targets:
			line_target = each_navpoint.global_position
			#line_target.y += DEBUG_SHIFT
			DebugDraw3D.draw_line_hit_offset(
				line_start, # start: Vector3, 
				line_target, #end: Vector3, 
				true, #is_hit: bool, 
				target_distance / (line_target.distance_to(global_position)+.01) , #unit_offset_of_hit: float = 0.5, percentage
				.15, #hit_size: float = 0.25, 
				#hit_color: Color = Color(0, 0, 0, 0), 
				#after_hit_color: Color = Color(0, 0, 0, 0), 
				#duration: float = 0)
				)

func get_next_point() -> NavPoint3D: 
	if next_targets.is_empty():
		return null
	return next_targets.pick_random()
	#return _picker.pick_one()

func get_target_location() -> Vector3: 
	var v2 : Vector2 = Vector2.from_angle(randf() * TAU) * target_distance *.5 #+ global_position
	var v3 : Vector3 = global_position + Vector3(v2.x, 0.0, v2.y)
	if is_colliding():
			v3.y = get_collision_point().y
	return v3

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:Array = []
	if next_targets.has(self):
		warnings.append("Nav points back to itself")
	elif next_targets.is_empty() and !is_disabled:
		warnings.append("No next nav points set.")
	elif !next_targets.is_empty() and is_disabled:
		warnings.append("Nav points set but is Disabled.")
	return warnings

func prune_targets() -> void:
	var remove: Array[NavPoint3D]
	for each in next_targets:
		if each == null:
			remove.append(each)
		elif each.is_disabled:
			remove.append(each)
	while !remove.is_empty():
		next_targets.erase(remove.pop_back())

class WeightedPicker:
	var _total: float = 0.0
	var _choices: Array[NavPointWeight]
	
	func _init(array: Array[NavPointWeight]) -> void: 
		populate_choices(array)
	
	func pick_one() -> NavPoint3D:
		if _choices.is_empty():
			return null
		if _choices.size() == 1:
			#return _choices[0].get_nav_point()
			return null
		var roll : float = randf_range(0, _total)
		var current_weight : float = 0.0
		for each in _choices:
			current_weight = each.get_weight()
			if roll <= current_weight:
				#return each.get_nav_point()
				return null
			roll -= current_weight
		return null

	func populate_choices(array: Array[NavPointWeight]) -> void: 
		var weight: float
		if _total != 0.0:
			push_warning("_total didn't start at 0.0") # because I removed _total = 0.0 and want to make sure i don't need it
		for each_ in array:
			weight = each_.get_weight()
			if weight > 0.0:
				_choices.append(each_)
				_total += weight
