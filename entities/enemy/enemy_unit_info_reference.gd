class_name EnemyUnitInfo_reference extends Resource

enum EnemyTypes {
	_OG_SCOUT = -10, 
	_OG_GUNMAN = -11,
	_OG_RIFLE = -12,
	_OG_GRENADIER = -13, 
	_OG_TANK = -20,
	_OG_HELICOPTER = -30,
	DEBUG_WALKER=0,
	DEBUG_SHOOTER = 1,
	#SCOUT=100, 
	#GUN=110, RIFLE=120, GRENADIER=130, 
	#TANK=200, 
	#HELICOPTER=300
	}

enum EnemySpawnTypes {NA=0,
	PERSON = 100, VEHICLE_GROUND = 200, VEHICLE_AIR=300}

static var MapEnemyTypeMeta: Dictionary[EnemyTypes, EnemySpawnTypes] = {
	EnemyTypes._OG_SCOUT: EnemySpawnTypes.PERSON,
	EnemyTypes._OG_GUNMAN: EnemySpawnTypes.PERSON,
	EnemyTypes._OG_RIFLE :EnemySpawnTypes.PERSON,
	EnemyTypes._OG_GRENADIER :EnemySpawnTypes.PERSON,
	EnemyTypes._OG_TANK : EnemySpawnTypes.VEHICLE_GROUND,
	EnemyTypes._OG_HELICOPTER : EnemySpawnTypes.VEHICLE_AIR,
	
	EnemyTypes.DEBUG_WALKER: EnemySpawnTypes.PERSON, 
	EnemyTypes.DEBUG_SHOOTER: EnemySpawnTypes.PERSON, 
}

static var EnemyScenePaths : Dictionary[EnemyTypes, String] = {
	EnemyTypes._OG_SCOUT: "uid://dw14xfa1aivcl",
	EnemyTypes._OG_GUNMAN: "uid://dcojfcwegryeo",
	EnemyTypes._OG_RIFLE :"uid://byga14u4wj7w",
	EnemyTypes._OG_GRENADIER :"uid://coomq7s2gmil3",
	EnemyTypes._OG_TANK :"uid://d2b7i20fjuoga",
	EnemyTypes._OG_HELICOPTER :"uid://c5cfbf3p4ar8n",
	
	EnemyTypes.DEBUG_WALKER: "uid://ffqucx6xrr6f",
	EnemyTypes.DEBUG_SHOOTER: "uid://drfqmnxu83xf6",
}

static func get_enemy_scene_path(enemy_type: EnemyTypes) -> String: return EnemyScenePaths.get(enemy_type, "")
