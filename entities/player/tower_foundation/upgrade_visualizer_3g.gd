class_name UpgradeVisualizer3D extends UpgradeVisualizer

@export var nodes : Dictionary[FoundationUpgrades.UpgradeTypes, MeshInstance3D]

func _ready() -> void:
	for node in nodes.values():
		node.set_mesh(node.get_mesh().duplicate())
		node.get_mesh().set_material(StandardMaterial3D.new())
		node.get_mesh().get_material().set_transparency(true)
	super._ready()

func _on_upgrade_changed() -> void:
	var ratio = 0.0
	var mesh: MeshInstance3D
	for upgrade : FoundationUpgrades.UpgradeTypes in nodes.keys():
		mesh = nodes.get(upgrade, null)
		if mesh:
			if _upgrades:
				ratio =  _upgrades.get_upgrade_ratio(upgrade)
			mesh.get_mesh().get_material().albedo_color.a = ratio
