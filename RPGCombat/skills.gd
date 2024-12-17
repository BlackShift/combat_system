class_name Skill extends Resource

enum TARGET_MODE {SUB_SKILL,SINGLE,MULTI,ALL}
enum TARGET_FILTER {SELF=1,ENEMY=2,ALLY=4}

@export var name:String
@export var description:String
@export var parent:Skill
@export var visible:bool

@export var target_mode:TARGET_MODE = TARGET_MODE.SINGLE
@export_flags("SELF:1","ENEMY:2","ALLY:4") var target_filter:int = TARGET_FILTER.ENEMY

@warning_ignore("unused_signal")
signal use(turn:Turn)
@warning_ignore("unused_signal")
signal process(turn:Turn)

static func filter_by_parent(skillparent:Skill,list:Array[Skill]) -> Array[Skill]:
	var result:Array[Skill]
	for s:Skill in list:
		if s.parent == skillparent:
			result.append(s)
	return result
