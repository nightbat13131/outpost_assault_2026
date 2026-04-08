@tool
class_name CollitionShape3D_Enhanced extends CollisionShape3D

## A mesh to mimic the size of. Assumes a shared parent for position.
@export var mimic_mesh: MeshInstance3D


func _ready() -> void:
	if !Engine.is_editor_hint():
		return
	_engine_resize()

func _engine_resize() -> void:
	if mimic_mesh == null:
		return
	var mesh: Mesh = mimic_mesh.get_mesh()
	if mesh is BoxMesh:
		if get_shape() is BoxShape3D:
			set_position(mimic_mesh.get_position())
			get_shape().set_size(mesh.get_size())
	elif mesh is SphereMesh:
		if get_shape() is SphereShape3D:
			set_position(mimic_mesh.get_position())
			get_shape().set_radius(mesh.radius)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings : Array[String]
	if mimic_mesh:
		if mimic_mesh.get_parent() != self.get_parent():
			warnings.append("Self and Mimic do not share parents.")
	return warnings
