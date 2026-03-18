class_name EnemyUnitInfo_reference extends Resource

enum EnemyTypes {
	_OG_SCOUT = -10, 
	_OG_GUNMAN = -11,
	DEBUG_WALKER=0, 
	SCOUT=100, 
	GUN=110, RIFLE=120, GRENADIER=130, 
	TANK=200, 
	HELICOPTER=300
	}

enum EnemySpawnTypes {NA=0,
	PERSON = 100, VEHICLE_GROUN = 200, VEHICLE_AIR=300}

static var MapEnemyTypeMeta: Dictionary[EnemyTypes, EnemySpawnTypes] = {
	EnemyTypes._OG_SCOUT: EnemySpawnTypes.PERSON,
	EnemyTypes._OG_GUNMAN: EnemySpawnTypes.PERSON,
	EnemyTypes.DEBUG_WALKER: EnemySpawnTypes.PERSON, 
	EnemyTypes.SCOUT: EnemySpawnTypes.PERSON, 
	EnemyTypes.GUN: EnemySpawnTypes.PERSON
}

static var EnemyScenePaths : Dictionary[EnemyTypes, String] = {
	EnemyTypes._OG_SCOUT: "uid://dw14xfa1aivcl",
	EnemyTypes._OG_GUNMAN: "uid://dcojfcwegryeo",
	
	EnemyTypes.DEBUG_WALKER: "uid://ffqucx6xrr6f",
	EnemyTypes.SCOUT: "uid://ffqucx6xrr6f",
	EnemyTypes.GUN: "uid://drfqmnxu83xf6",
}

static func get_enemy_scene_path(enemy_type: EnemyTypes) -> String: return EnemyScenePaths.get(enemy_type, "")
