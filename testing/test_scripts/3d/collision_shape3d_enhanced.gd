#@tool
class_name CollisionShape3D_Enhanced extends CollisionShape3D

## A mesh to mimic the size of. Assumes a shared parent for position, or at least Vector.Zero parents. 
@export var mimic_mesh: MeshInstance3D


func _ready() -> void:
	if !Engine.is_editor_hint():
		return
	_engine_resize()

func get_y_offset() -> float:
	var out := -.5
	var _shape = get_shape()
	if _shape is SphereShape3D:
		out = _shape.radius *-1
	## todo: calculate based on shape and stuff
	return out

func _engine_resize() -> void:
	if mimic_mesh == null:
		return
	var mesh: Mesh = mimic_mesh.get_mesh()
	#set_global_position(mimic_mesh.get_global_position())
	if mesh is BoxMesh:
		#if get_shape() is BoxShape3D:
		set_shape(BoxShape3D.new())
		set_position(mimic_mesh.get_position())
		get_shape().set_size(mesh.get_size())
	elif mesh is SphereMesh:
		if get_shape() is SphereShape3D:
			set_position(mimic_mesh.get_position())
			get_shape().set_radius(mesh.radius)
	elif mesh is CylinderMesh:
		if get_shape() is CylinderShape3D:
			get_shape().set_radius((mesh.get_top_radius() + mesh.get_bottom_radius())*.5)
			get_shape().set_height(mesh.get_height())
			set_rotation(mimic_mesh.get_rotation())


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : Array[String]
	if mimic_mesh:
		if mimic_mesh.get_parent() != self.get_parent():
			#warnings.append("Self and Mimic do not share parents.")
			pass
	else: 
		warnings.append("No Mimic selected.")
	return warnings
