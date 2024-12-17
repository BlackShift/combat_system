extends Node3D
@onready var diamond: MeshInstance3D = $diamond

@export var target:Node3D:
	set(v):
		if !is_node_ready():
			set_deferred(&"target",v)
			return
		target = v
		var bounds:AABB
		for mesh:MeshInstance3D in target.find_children("*","MeshInstance3D"):
			bounds = bounds.merge(mesh.get_aabb() * mesh.global_transform)
		offset = Vector3(0,bounds.size.y,0)
		position = Vector3.ZERO
var offset:Vector3
@export var color:Color = Color.RED

var showhide_tween:Tween
const showhide_time = 0.5
const spin_speed = 1
func _ready() -> void:
	if target:
		global_position = target.global_position
	#play_show.call_deferred()
	diamond["instance_shader_parameters/albedo"] = Color(color,0.0)
	#Start Hidden
	#diamond["instance_shader_parameters/albedo:a"] = 0.0
	diamond["instance_shader_parameters/grow"] = 4.0

func play_show():
	if showhide_tween and showhide_tween.is_running():
		showhide_tween.kill()
	
	showhide_tween = create_tween()
	diamond["instance_shader_parameters/albedo:a"] = 0.0
	diamond["instance_shader_parameters/grow"] = 4.0
	showhide_tween.set_parallel()
	showhide_tween.set_trans(Tween.TRANS_CUBIC)
	showhide_tween.set_ease(Tween.EASE_OUT)
	showhide_tween.tween_property(diamond,"instance_shader_parameters/albedo:a",color.a,showhide_time)
	showhide_tween.tween_property(diamond,"instance_shader_parameters/grow",0.0,showhide_time)

func play_hide():
	if showhide_tween and showhide_tween.is_running():
		showhide_tween.kill()
		
	showhide_tween = create_tween()
	diamond["instance_shader_parameters/albedo:a"] = color.a
	diamond["instance_shader_parameters/grow"] = 0.0
	showhide_tween.set_parallel()
	showhide_tween.set_trans(Tween.TRANS_CUBIC)
	showhide_tween.set_ease(Tween.EASE_IN)
	showhide_tween.tween_property(diamond,"instance_shader_parameters/albedo:a",0.0,showhide_time)
	showhide_tween.tween_property(diamond,"instance_shader_parameters/grow",4.0,showhide_time)
	
func _process(delta: float) -> void:
	diamond.rotate_y(delta * spin_speed)
	global_position = target.global_position + offset
