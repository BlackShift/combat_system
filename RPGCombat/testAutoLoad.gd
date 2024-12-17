extends Node
var b:Battle
func _ready() -> void:
	b = Battle.new()
	b.lock(Battle.LOCK_ANIM)
	b.lock(Battle.LOCK_OTHER)
	print(b._lock)
	b.unlock(Battle.LOCK_ANIM)
	print(b._lock)
	
	var t := Turn.new(Actor.new(),b)
	t.start.connect(turn_start)
	t.proccess.connect(turn_process.bind(t))
	t.end.connect(turn_end)
	b.add_turn(t)
	
func turn_process(t:Turn):
	print("processing turn")
	t.mark_end()

func _process(delta: float) -> void:
	b.proccess(delta)

func turn_start():
	print("Turn Started")



func turn_end():
	print("turn ended")
