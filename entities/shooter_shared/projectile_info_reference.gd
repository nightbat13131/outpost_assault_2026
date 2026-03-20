class_name ProjectileInfo_reference extends Resource

enum ProjectileType { 
	NA = 0, 
	BULLET = 1,
	MISSILE = 2, 
	GRENADE = 3, 
	SHELL = 4,
}

static var projectile_paths : Dictionary[ProjectileType, String] = {
	ProjectileType.BULLET: "uid://fmyfpa2i8oox", 
	ProjectileType.MISSILE: "", 
	ProjectileType.GRENADE: "",
	ProjectileType.SHELL: "",
}

static func get_projectile_type_path(_projectile_type: ProjectileType) -> String:
	# TODO: return dynamic path
	return projectile_paths.get(ProjectileType.BULLET, "uid://fmyfpa2i8oox")
