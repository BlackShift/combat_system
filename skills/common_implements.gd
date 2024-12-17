extends Node
const ATTACK = preload("res://combat_system/skills/attack.tres")
const ATTACK_STAT = preload("res://combat_system/stats/attack.tres")
const HEALTH_STAT = preload("res://combat_system/stats/health.tres")
const FIRE_BALL = preload("res://combat_system/skills/spells/fire_ball.tres")

func _ready() -> void:
	bind_implementations()
	
func bind_implementations() -> void:
	ATTACK.use.connect(attack)
	FIRE_BALL.use.connect(fire_ball)
	pass

func fire_ball(t:Array[Actor],turn:Turn):
	pass

func attack(t:Array[Actor],turn:Turn):
	print(turn.actor.name," attacks!")
	var dmg:float = 10
	if turn.actor.has_stat(ATTACK_STAT):
		dmg = roundf(turn.actor.get_value(ATTACK_STAT))
	
	for target:Actor in t:
		if target.has_stat(HEALTH_STAT):
			var state := target.get_state(HEALTH_STAT)
			state.value -= dmg
