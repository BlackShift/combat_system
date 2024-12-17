class_name SubSkillList extends AnimatedRegion

@export var skills:Array[Skill]
@onready var skill_container: VBoxContainer = $PanelContainer/SkillContainer
const SKILL_LABEL = preload("res://combat_system/RPGCombat/ui/skill_label.tscn")

signal skill_used(s:Skill)
signal closed()

func update_label(skill:Skill,control:SkillLabel) -> void:
	control.label_name.text = skill.name

func _ready() -> void:
	super()
	for s in skills:
		var skill_label := SKILL_LABEL.instantiate()
		skill_label.ready.connect(update_label.bind(s,skill_label))
		skill_container.add_child(skill_label)
		skill_label.pressed.connect(func(): skill_used.emit(s))

func _handle_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		closed.emit.call_deferred()

func _gui_input(event: InputEvent) -> void:
	_handle_input(event)

func _unhandled_input(event: InputEvent) -> void:
	_handle_input(event)
