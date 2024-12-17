class_name SkillLabel extends Control

signal pressed()

@onready var use: Button = %Use
@onready var label_name: Label = %Name
@onready var cost: Label = %Cost

func _ready() -> void:
	use.pressed.connect(func(): pressed.emit())
