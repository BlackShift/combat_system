extends VBoxContainer

@export var actor:Actor
@onready var animated_region: AnimatedRegion = $AnimatedRegion
@onready var actor_name: Label = %ActorName
@onready var secondary_label: Label = %SecondaryLabel
@onready var secondary_bar: SolidProgressBar = $PanelContainer/HBoxContainer/SecondaryLabel/SecondaryBar
@onready var primary_label: Label = %PrimaryLabel
@onready var primary_bar: SolidProgressBar = $PanelContainer/HBoxContainer/PrimaryLabel/PrimaryBar
@onready var button_list: VBoxContainer = %ButtonList

func _ready() -> void:
	actor_name.text = actor.name
	var primary = actor.primary_stat
	if primary:
		var updater = update_control.bind(primary_label,primary_bar,primary)
		updater.call()
		actor.get_state(primary).changed.connect(updater)
	else:
		primary_bar.visible = false
		primary_label.visible = false
		primary_bar.queue_free()
		primary_label.queue_free()
	
	var secondary = actor.secondary_stat
	if secondary:
		var updater = update_control.bind(secondary_label,secondary_bar,secondary)
		updater.call()
		actor.get_state(secondary).changed.connect(updater)
	else:
		secondary_bar.visible = false
		secondary_label.visible = false
		secondary_bar.queue_free()
		secondary_label.queue_free()
	
	pass

func show_controls() -> void:
	animated_region.window_open()
	pass

func hide_controls() -> void:
	animated_region.window_close()
	pass

func update_control(label:Label,bar:SolidProgressBar,stat:Stat) -> void:
	var max_value = actor.get_max(stat)
	var state = actor.get_state(stat)
	var current_value = state.value
	label.text = str(current_value) + "/" + str(max_value)
	bar.fill_color = stat.color
	bar.percent_fill = current_value/max_value
	pass
