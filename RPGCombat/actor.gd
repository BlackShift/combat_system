@tool
class_name Actor extends Resource

enum TEAM {ALLY,ENEMY}

@export var stats:Array[StatState]
@export var skills:Array[Skill]
@export var name:String
@export var primary_stat:Stat
@export var secondary_stat:Stat
@export var level:int
@export var team:TEAM

## Returns -1.0 on failure
func get_max(s:Stat) -> float:
	for state in stats:
		if state.stats != s:
			continue
		return floori(state.level_curve.sample(level))
	return -1.0

func get_value(s:Stat) -> float:
	for state in stats:
		if state.stats == s:
			return state.value
	return -1.0

func has_stat(s:Stat) -> float:
	for state in stats:
		if state.stats == s:
			return true
	return false

func get_state(s:Stat) -> StatState:
	for state in stats:
		if state.stats == s:
			return state
	return null

func has_skill(s:Skill):
	return skills.has(s)
