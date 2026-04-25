extends Area3D
## started from https://github.com/godotengine/godot-demo-projects/blob/master/viewport/gui_in_3d/gui_3d.gd, but much mutilated since then.

@export var mesh_quad: MeshInstance3D
@export var mesh_color : MeshInstance3D
@export var node_viewport : SubViewport
@onready var node_area : Area3D = self

@onready var mouse_interaction_node: MouseInteractionNode # = %MouseInteractionNode

#var mesh_material: Material

## The last processed input touch/mouse event. Used to calculate relative movement.
var last_event_pos2D := Vector2()

## The time of the last event in seconds since engine start.
var last_event_time := -1.0

## Used for checking if the mouse is inside the Area3D.
var is_mouse_inside: bool = true:
	set(value):
		if is_mouse_inside == value:
			return # no change
		is_mouse_inside = value
		if mesh_color:
			if is_mouse_inside:
				mesh_color.get_mesh().get_material().set_albedo(Color.GREEN)
				#mesh_material.set_albedo(Color.GREEN)
			else:
				#mesh_material.set_albedo(Color.RED)
				mesh_color.get_mesh().get_material().set_albedo(Color.RED)

func _ready() -> void:
	for each_child in get_children():
		if each_child is MouseInteractionNode:
			mouse_interaction_node = each_child
			mouse_interaction_node.selected.connect(_on_selected)
			mouse_interaction_node.mouse_in.connect(_on_mouse_in)
			break
	is_mouse_inside = false

func _on_selected() -> void:
	
	pass

func _on_mouse_in(is_in: bool) -> void: is_mouse_inside = is_in
