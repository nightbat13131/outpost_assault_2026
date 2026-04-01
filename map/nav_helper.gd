@tool
class_name NavPoint extends Node2D
## NavigationLinks MIGHT serve this purpose, but I like the controle I have so far...
## Helper class to manually guide NavigationAgent2D

#@export var next_target_weights: Dictionary[NavPoint, int] # started crashing the engine after about 30 minutes
## Paths for next nav points and their weights. 
#@export var next_target_weights: Array[NavPointWeight] = []
#@onready var _picker: WeightedPicker

## If I really want weighted splits between next target, I can add it mulitple times. 
@export var next_targets : Array[NavPoint]
## For disabling the nav point when it has to be on screen but not being used. 
@export var is_disabled := false
## The distance threshold before the target is considered to be reached.
@export var target_distance := 20.0 :
	set(value):
		target_distance = abs(value)
		queue_redraw()


func _ready() -> void:
	if is_disabled:
		if Engine.is_editor_hint():
			return
		#queue_free()
		return
	prune_targets()
	#for each in next_target_weights:
	#	if each:
	#		each.set_parent(self)
	#_picker = WeightedPicker.new(next_target_weights)

func _draw() -> void:
	if is_disabled:
		return
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, target_distance, Color.RED, false, 3.0)
		# no destination dimond
		if next_targets.is_empty():
			draw_polyline(
				[Vector2.from_angle(TAU*.25)*target_distance,
				Vector2.from_angle(TAU*.5)*target_distance,
				Vector2.from_angle(TAU*.75)*target_distance,
				Vector2.from_angle(TAU*1.0)*target_distance,
				Vector2.from_angle(TAU*.25)*target_distance,
				],
				Color.ORANGE, 2)
		else:
			var end_point : Vector2
			var poly_points : Array[Vector2]
			var tri_sides := 40.0
			for each_point: NavPoint in next_targets:
				if each_point:
					if !each_point.is_disabled:
						end_point = to_local(each_point.global_position)
						poly_points = [
							Vector2.from_angle(end_point.angle()-.2)*tri_sides*1,
							Vector2.from_angle(end_point.angle())   *tri_sides*1.25, ## tip
							Vector2.from_angle(end_point.angle()+.2)*tri_sides*1,
						]
						poly_points.append(poly_points[0])
						draw_line(Vector2.ZERO, end_point, Color.ORANGE, 4)
						draw_polyline(poly_points, Color.BLUE, 2)

#func _draw_0() -> void:
	#if is_disabled:
		#return
	#if Engine.is_editor_hint():
		#draw_circle(Vector2.ZERO, target_distance, Color.RED, false, 3.0)
		#if next_target_weights.is_empty():
			#draw_polyline(
				#[Vector2.from_angle(TAU*.25)*target_distance,
				#Vector2.from_angle(TAU*.5)*target_distance,
				#Vector2.from_angle(TAU*.75)*target_distance,
				#Vector2.from_angle(TAU*1.0)*target_distance,
				#Vector2.from_angle(TAU*.25)*target_distance,
				#],
				#Color.ORANGE, 2)
		#else:
			#var end_point : Vector2
			#for each_point: NavPointWeight in next_target_weights:
				#if each_point.get_nav_point():
					#if !each_point.get_nav_point().is_disabled:
						#end_point = to_local(each_point.get_nav_point().global_position)
						#draw_line(Vector2.ZERO, end_point, Color.ORANGE, each_point.get_weight()*4)
						#draw_polyline([
							#Vector2.from_angle(end_point.angle()-.2)*target_distance*1,
							#Vector2.from_angle(end_point.angle())   *target_distance*1.25,
							#Vector2.from_angle(end_point.angle()+.2)*target_distance*1,
							#],
					#Color.BLUE, 2)

func get_next_point() -> NavPoint: 
	if next_targets.is_empty():
		return null
	return next_targets.pick_random()
	#return _picker.pick_one()

func get_target_location() -> Vector2: 
	return Vector2.from_angle(randf() * TAU) * target_distance *.5 + global_position
	#return global_position

func apply_nav_agent(nav_agent: NavigationAgent2D) -> void:
	if nav_agent:
		### version 1 - towards center with target_distance as buffer 
		## Gives very consisten path
		#nav_agent.set_target_position(global_position)
		#nav_agent.set_target_desired_distance(target_distance)
		
		### version 2 - towards random point near center bound within target_distance
		## much better spread for travel, corners are still tightly hugged. Graphics might help.
		nav_agent.set_target_position(
			get_target_location()
			)
		nav_agent.set_target_desired_distance(target_distance * .5) # 5 is too small and nav agent gets stuck trying to be close enough

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
	var remove: Array[NavPoint]
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
	
	func pick_one() -> NavPoint:
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
