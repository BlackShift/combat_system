class_name Battle extends Object

const SPEED_STAT = preload("res://combat_system/stats/agility.tres")

static var current_battle:Battle

signal battle_started
signal battle_ended

signal turn_start(t:Turn)
signal turn_end(t:Turn)
signal no_turns()

signal log(msg:String)

enum LOCK {NONE = 0,ANIM,SELECTION,OTHER}
const LOCK_ANIM = LOCK.ANIM
const LOCK_SELECTION = LOCK.SELECTION
const LOCK_OTHER = LOCK.OTHER
const LOCK_NONE = LOCK.NONE

var _lock:int = 0
var lock_mask:int = 0

var _turn_stack:Array[Turn]
var _turn_processing: Turn

var _participants:Array[Actor]

func _init():
	pass

func add_actor(a:Actor) -> void:
	_participants.append(a)

func get_actors() -> Array[Actor]:
	return _participants.duplicate()

func get_actors_with_filter(source:Actor,filter) -> Array[Actor]:
	var results:Array[Actor]
	var source_team = source.team
	if filter & Skill.TARGET_FILTER.ENEMY:
		for a in _participants:
			if a == source:
				continue
			if a.team != source_team:
				results.append(a)

	if filter & Skill.TARGET_FILTER.ALLY:
		for a in _participants:
			if a == source:
				continue
			if a.team == source_team:
				results.append(a)
	if filter & Skill.TARGET_FILTER.SELF:
		results.append(source)
	return results

func process(_delta) -> void:
	if _turn_processing:
		_turn_processing.proccess.emit()
		if _turn_processing.state == Turn.ENDED:
			print("End turn")
			_turn_processing.end.emit()
			turn_end.emit(_turn_processing)
			_turn_processing.free()
			_turn_processing = null
		pass
	else:
		_turn_processing = _turn_stack.pop_front() as Turn
		if _turn_processing:
			turn_start.emit(_turn_processing)
			_turn_processing.start.emit()
			print("Start turn")
		else:
			no_turns.emit()
	pass

func _speed_sort(a:Actor,b:Actor):
	return a.get_value(SPEED_STAT) > b.get_value(SPEED_STAT)

func get_participents_by_speed() -> Array[Actor]:
	var turn_order = _participants.duplicate()
	turn_order.sort_custom(_speed_sort)
	return turn_order
	#_turn_stack.append_array(turn_order)
	
func add_turn(turn:Turn) -> void:
	_turn_stack.append(turn)
	
func add_turns(turn:Array[Turn]) -> void:
	_turn_stack.append_array(turn)

func lock(l:LOCK) -> void:
	_lock |= l ^ lock_mask
	
func unlock(l:LOCK) -> void:
	_lock &= ~l

func trylock() -> bool:
	if _lock:
		return false
	else:
		return true
