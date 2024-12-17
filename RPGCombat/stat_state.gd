class_name StatState extends Resource

@export var stats:Stat
@export var level_curve:Curve
@export var value:float:
	set(v):
		value = v
		emit_changed()
