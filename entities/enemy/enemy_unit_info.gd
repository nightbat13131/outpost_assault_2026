class_name EnemyUnitInfo extends Resource

enum EnemyTypes {
	DEBUG_WALKER=0, 
	SCOUT=100, 
	GUN=110, RIFLE=120, GRENADIER=130, 
	TANK=200, 
	HELICOPTER=300 }

static var EnemyScenePaths : Dictionary[EnemyTypes, String] = {
	EnemyTypes.DEBUG_WALKER: "uid://ffqucx6xrr6f",
	EnemyTypes.GUN: "uid://drfqmnxu83xf6",
	
}

@export var speed: float = 150.0
## Pixels per second
@export var rotate_speed_body := 10.0
## Degrees per second 
@export var max_health := 100.0 : get = get_max_health
## Unit Starting health
@export var kill_reward := 100.0
## Gold awarded upon death

enum EnemySpawnTypes {NA=0,
	PERSON = 100, VEHICLE_GROUN = 200, VEHICLE_AIR=300}

static var MapEnemyTypeMeta: Dictionary[EnemyTypes, EnemySpawnTypes] = {
	EnemyTypes.DEBUG_WALKER: EnemySpawnTypes.PERSON, 
	EnemyTypes.SCOUT: EnemySpawnTypes.PERSON, 
	EnemyTypes.GUN: EnemySpawnTypes.PERSON
}

func get_max_speed() -> float: return speed

static func get_enemy_scene_path(enemy_type: EnemyTypes) -> String: return EnemyScenePaths.get(enemy_type, "")

func get_max_health() -> float: return max_health
