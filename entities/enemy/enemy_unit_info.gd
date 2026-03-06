class_name EnemyUnitInfo extends Resource

enum EnemyTypes {
	DEBUG_WALKER=0, 
	SCOUT=100, 
	GUN=110, RIFLE=120, GRENADIER=130, 
	TANK=200, 
	HELICOPTER=300 }

static var EnemyScenePaths : Dictionary[EnemyTypes, String] = {
	EnemyTypes.DEBUG_WALKER: "uid://ffqucx6xrr6f",
	EnemyTypes.SCOUT: "uid://ffqucx6xrr6f",
	EnemyTypes.GUN: "uid://drfqmnxu83xf6",
}

## Damage delt to Outpost if unit gets there
@export var _outpost_damage := 10.0
## Pixels per second
@export var speed: float = 150.0
## Degrees per second 
@export var rotate_speed_body_deg := 10.0
## Unit Starting health
@export var max_health := 100.0 : get = get_max_health
## Gold awarded upon death
@export var kill_reward := 100.0 : get =get_kill_reward


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

func get_kill_reward() -> float: return kill_reward

func get_outpost_damange() -> float: return _outpost_damage

func get_body_rotate_limit_radian() -> float: return deg_to_rad(rotate_speed_body_deg)
