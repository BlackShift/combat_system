@tool
class_name SolidProgressBar extends Control


enum GROW_DIRECTION {LEFT,RIGHT,TOP,BOTTOM}
@export var fill_color:Color:
	set(value):
		fill_color = value
		queue_redraw()
@export_range(0,1) var top_ratio:float:
	set(value):
		top_ratio = value
		queue_redraw()
@export_range(0,1) var bottom_ratio:float:
	set(value):
		bottom_ratio = value
		queue_redraw()
@export_range(0,1) var left_ratio:float:
	set(value):
		left_ratio = value
		queue_redraw()
@export_range(0,1) var right_ratio:float:
	set(value):
		right_ratio = value
		queue_redraw()
@export_range(0,1) var percent_fill:float = 1.0:
	set(value):
		percent_fill = value
		queue_redraw()
@export var grow:GROW_DIRECTION = GROW_DIRECTION.RIGHT:
	set(value):
		grow = value
		queue_redraw()

func _ready() -> void:
	resized.connect(queue_redraw)

func _draw() -> void:
	var fillarea := Rect2()
	fillarea.size.x = size.x - (right_ratio * size.x) - (left_ratio * size.x)
	fillarea.size.y = size.y - (top_ratio * size.y) - (bottom_ratio * size.y)
	fillarea.position.x = left_ratio * size.x
	fillarea.position.y = top_ratio * size.y
	#Add(Subtract) in percent fill
	match grow:
		GROW_DIRECTION.LEFT:
			fillarea = fillarea.grow_side(SIDE_LEFT, -fillarea.size.x * (1.0 - percent_fill))
			pass
		GROW_DIRECTION.RIGHT:
			fillarea = fillarea.grow_side(SIDE_RIGHT, -fillarea.size.x * (1.0 - percent_fill))
			pass
		GROW_DIRECTION.TOP:
			pass
		GROW_DIRECTION.BOTTOM:
			pass
	
	
	draw_rect(fillarea,fill_color)
