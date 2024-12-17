@tool
class_name RPGMakerStyleBox extends StyleBox

@export var center_texture: Texture2D
@export var texture_filter := RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_DEFAULT
@export var texture_reset := RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_DEFAULT
@export var style_box: StyleBoxTexture
@export var modulate := Color.WHITE
@export_category("Center Margin")
@export var left:int = -1
@export var right:int = -1
@export var top:int = -1
@export var bottom:int = -1
	
func _draw(to_canvas_item, rect):
	#calculate texture region
	var new_rect = Rect2()
	new_rect.position.x = rect.position.x + left
	new_rect.position.y = rect.position.x + top
	new_rect.size.x = rect.size.x - right - left
	new_rect.size.y = rect.size.y - bottom - top
	RenderingServer.canvas_item_add_texture_rect_region(to_canvas_item,new_rect,\
	center_texture.get_rid(),\
	Rect2(Vector2(),center_texture.get_size())\
	,modulate)
	
	#RenderingServer.canvas_item_add_texture_rect(to_canvas_item,rect,center_texture.get_rid())
	style_box.draw(to_canvas_item,rect)
	
