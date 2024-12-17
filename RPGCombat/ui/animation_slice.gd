class_name AnimatedRegion extends Control

enum SWIPE_MODE {LEFT_TO_RIGHT,RIGHT_TO_LEFT,TOP_TO_BOTTOM,BOTTOM_TO_TOP}

@export var mode:SWIPE_MODE = SWIPE_MODE.LEFT_TO_RIGHT
@export var anim_duration:float = 1.0
@export var controlled_by_container: bool = false
@export var start_closed:bool = true
var original_size : Vector2
var minimized_size : Vector2
var original_position : Vector2
var minimized_position : Vector2

var animation_tween:Tween
var _scrollcontainers:Dictionary
var _buttons:Dictionary

func _ready() -> void:
	original_size = size
	original_position = position
	print(self, "is ready!")
	match mode:
		SWIPE_MODE.LEFT_TO_RIGHT:
			minimized_size = original_size
			minimized_size.x = 0
			minimized_position = original_position
		SWIPE_MODE.RIGHT_TO_LEFT:
			minimized_position = original_position
			minimized_position.x += original_size.x
			
			minimized_size = original_size
			minimized_size.x = 0
		SWIPE_MODE.TOP_TO_BOTTOM:
			minimized_size = original_size
			minimized_size.y = 0
	
	if controlled_by_container:
		custom_minimum_size = minimized_size
	else:
		position = minimized_position
		size = minimized_size
	
	hide_bars()
	disable_buttons()
	if start_closed:
		window_open()

func hide_bars() -> void:
	for s:ScrollContainer in find_children("*","ScrollContainer") as Array[ScrollContainer]:
		_scrollcontainers[s] = { "vert": s.vertical_scroll_mode, "horiz": s.horizontal_scroll_mode }
		s.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
		s.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER

func show_bars() -> void:
	for s:ScrollContainer in _scrollcontainers:
		s.horizontal_scroll_mode = _scrollcontainers[s]["horiz"]
		s.vertical_scroll_mode = _scrollcontainers[s]["horiz"]

func window_open() -> void:
	if animation_tween && animation_tween.is_running():
		return
	animation_tween = create_tween()
	animation_tween.set_parallel()
	if controlled_by_container:
		animation_tween.tween_property(self,"custom_minimum_size",original_size,anim_duration)
	else:
		animation_tween.tween_property(self,"size",original_size,anim_duration)
		animation_tween.tween_property(self,"position",original_position,anim_duration)
	animation_tween.finished.connect(window_opened)
	
func disable_buttons() -> void:
	for b:BaseButton in find_children("*","BaseButton"):
		_buttons[b] = b.disabled
		b.disabled = true
	pass

func enable_buttons() -> void:
	for b:BaseButton in _buttons:
		b.disabled = _buttons[b]

func window_opened() -> void:
	enable_buttons()
	var b = find_children("*","Button")
	if b:
		b[0].grab_focus()
	show_bars()
		
func window_close() -> void:
	if animation_tween && animation_tween.is_running():
		return
	hide_bars()
	disable_buttons()
	animation_tween = create_tween()
	animation_tween.set_parallel()
	if controlled_by_container:
		animation_tween.tween_property(self,"custom_minimum_size",minimized_size,anim_duration)
	else:
		animation_tween.tween_property(self,"size",minimized_size,anim_duration)
		animation_tween.tween_property(self,"position",minimized_position,anim_duration)
	animation_tween.finished.connect(window_closed)
	pass

func window_closed() -> void:
	pass
