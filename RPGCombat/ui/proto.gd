extends Control

@onready var skill_box: Control = %SkillBox

const SKILL_LIST = preload("res://combat_system/RPGCombat/ui/subskill_list.tscn")
const ACTOR_BATTLE_CONTROL = preload("res://combat_system/RPGCombat/ui/actor_battle_control.tscn")
@export var actors:Array[Actor]
@onready var actor_box: HBoxContainer = $ActorBox
@export var menu_duration:float = 1
var _actor_controls:Dictionary
var _battle:Battle

var _pending_turns:Array[Turn]
var _turns:Array[Turn]
var current_turn_selection:Turn = null
var _prev_button_states:Dictionary

var nestedMenus:Array[Control]

func _ready() -> void:
	# Create a test battle
	_battle = Battle.new()
	# Add controls for each actor
	for a in actors:
		var c = ACTOR_BATTLE_CONTROL.instantiate()
		c.actor = a
		_actor_controls[a] = c
		
		actor_box.add_child(c)
		add_skills(a)
		_battle.add_actor(a)
	#_battle.no_turns.connect(next_round)
	next_round()

func next_round():
	for a:Actor in _battle.get_participents_by_speed():
		var t := Turn.new(a,_battle)
		t.start.connect(turn_start.bind(t))
		t.proccess.connect(t.mark_end)
		t.end.connect(turn_end.bind(t))
		_pending_turns.append(t)

func turn_start(_t:Turn):
	#Animate Turn start
	pass

func turn_end(_t:Turn):
	#Animate turn end
	pass

func _process(delta: float) -> void:
	if !current_turn_selection:
		current_turn_selection = _pending_turns.pop_front()
		if current_turn_selection:
			enable_actor(current_turn_selection.actor)
		else:
			# All actors have chosen their turns
			next_round()
			_battle.add_turns(_turns)
			_turns = []
			#_turns = [] as Array[Turn]
	_battle.process(delta)


## Removes and frees the current skill menu, then restores the previous menu
func pop_old_skill_menu(current:Control) -> void:
	if current is AnimatedRegion:
		current.window_close()
		await current.animation_tween.finished
		#current.queue_free()
	current.queue_free()
	
	var menu_to_be_displayed = nestedMenus.pop_back()
	if !menu_to_be_displayed:
		enable_actor_boxes()
		return
	skill_box.add_child(menu_to_be_displayed)
	if menu_to_be_displayed is AnimatedRegion:
		menu_to_be_displayed.window_open()
		menu_to_be_displayed.visible = true

func clear_spell_menu() -> void:
	for c in skill_box.get_children():
		if c is AnimatedRegion:
			c.visible = false
			c.window_close()
			await c.animation_tween.finished
		skill_box.remove_child(c)
	nestedMenus.clear()
	enable_actor_boxes()

func create_spell_menu(s:Skill,a:Actor):
	disable_actor_boxes()
	
	for c in skill_box.get_children():
		if c is AnimatedRegion:
			c.visible = false
			c.window_close()
			await c.animation_tween.finished
		skill_box.remove_child(c)
		nestedMenus.append(c)
		
	var skill_list = SKILL_LIST.instantiate()
	skill_list.skills = Skill.filter_by_parent(s,a.skills)
	skill_list.anim_duration = menu_duration
	skill_list.controlled_by_container = false
	skill_list.skill_used.connect(skill_used.bind(a))
	skill_list.closed.connect(pop_old_skill_menu.bind(skill_list))
	skill_list.size = skill_box.size
	skill_box.add_child(skill_list)

func skill_used(s: Skill,a:Actor):
	assert(a == current_turn_selection.actor,"Selecting turn actions out of order!")
	print("Actor: %s used skill " % a.name,s.name)
	if s.target_mode == Skill.TARGET_MODE.SUB_SKILL:
		create_spell_menu(s,a)
	else:
		clear_spell_menu()
	
	var targets = _battle.get_actors_with_filter(a,s.target_filter)
	var target_names = targets.map(func(el): return el.name)
	print("Valid Targets: ", target_names)
	if targets:
		current_turn_selection.proccess.connect(s.use.emit.bind(targets,current_turn_selection),CONNECT_REFERENCE_COUNTED)
		disable_actor(a)
		_turns.append(current_turn_selection)
		current_turn_selection = null

func disable_actor(a:Actor) -> void:
	_actor_controls[a].hide_controls()
	
func enable_actor(a:Actor) -> void:
	_actor_controls[a].show_controls()

func disable_actor_boxes() -> void:
	for b:BaseButton in actor_box.find_children("*","BaseButton",true,false):
		if !_prev_button_states.has(b):
			_prev_button_states[b] = b.disabled
		b.disabled = true

func enable_actor_boxes() -> void:
	for b:BaseButton in _prev_button_states:
		b.disabled = _prev_button_states[b]
	_prev_button_states.clear()
	
func add_skills(a: Actor):
	for s in a.skills:
		if s.parent != null or !s.visible:
			continue
		var b = Button.new()
		b.text = s.name
		b.pressed.connect(skill_used.bind(s,a))
		_actor_controls[a].button_list.add_child(b)
