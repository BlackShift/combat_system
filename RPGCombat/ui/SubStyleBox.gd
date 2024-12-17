@tool
##A Style box for alignment reasons...
class_name SubStyleBox extends StyleBox

@export var style_box: StyleBox
@export var padding:int = 0
func _draw(to_canvas_item, rect):
	var new_rect:Rect2 = rect.grow(-padding)
	if style_box:
		style_box.draw(to_canvas_item,new_rect)
