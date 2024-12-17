class_name Turn extends Object

enum STATE {NOT_STARTED=0,RUNNING,ENDED}
const NOT_STARTED = STATE.NOT_STARTED
const RUNNING = STATE.RUNNING
const ENDED = STATE.ENDED

var state:STATE

var actor:Actor
var battle:Battle

func _init(a:Actor,b:Battle) -> void:
	actor = a
	battle = b

@warning_ignore("unused_signal")
signal start()
@warning_ignore("unused_signal")
signal proccess()
@warning_ignore("unused_signal")
signal end()

func mark_end():
	state = ENDED
