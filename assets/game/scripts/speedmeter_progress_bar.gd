extends Node2D

class_name SpeedHUD

@export var pod_racer:PodRacer
@export var speedmeter:TextureProgressBar
@export var boostmeter:TextureProgressBar
@export var textbox:RichTextLabel
@export var name_textbox:RichTextLabel
@export var racer_portrait:Node3D
var initial_rotation:Vector3

var pitch_right:float = 0
var pitch_left:float = 0
var pitch_forward:float = 0
var pitch_back:float = 0

func _ready() -> void:
	initial_rotation = racer_portrait.rotation
	_update_connections()
	
func change_racer(new_pod_racer:PodRacer, new_racer_portrait:Node3D):
	pod_racer.accelerate.disconnect(_pod_racer_accelerate)
	pod_racer.boost.disconnect(_pod_racer_boost)
	pod_racer.brake.disconnect(_pod_racer_brake)
	pod_racer.right.disconnect(_pod_racer_right)
	pod_racer.left.disconnect(_pod_racer_left)
	
	pod_racer = new_pod_racer
	racer_portrait = new_racer_portrait
	_update_connections()
	
func _update_connections():
	name_textbox.text = "%s"%[pod_racer.racer_name]
	pod_racer.accelerate.connect(_pod_racer_accelerate)
	pod_racer.boost.connect(_pod_racer_boost)
	pod_racer.brake.connect(_pod_racer_brake)
	pod_racer.right.connect(_pod_racer_right)
	pod_racer.left.connect(_pod_racer_left)
	
func _pod_racer_accelerate(active:bool):
	if active:
		pitch_back = -10
	else:
		pitch_back = 0

func _pod_racer_boost(active:bool):
	if active:
		pitch_back = -25
	else:
		pitch_back = 0
		
func _pod_racer_brake(active:bool):
	if active:
		pitch_forward = 10
	else:
		pitch_forward = 0

func _pod_racer_right(active:bool):
	if active:
		pitch_right = -10
	else:
		pitch_right = 0

func _pod_racer_left(active:bool):
	if active:
		pitch_left = 10
	else:
		pitch_left = 0


func _process(_delta: float) -> void:
	speedmeter.max_value = pod_racer.max_velocity
	boostmeter.max_value = pod_racer.max_boost
	
	speedmeter.value = clampf(0.0, abs(pod_racer.linear_velocity.length()), pod_racer.max_velocity)
	boostmeter.value = clampf(0.0, pod_racer.current_boost, pod_racer.max_boost)
	_update_textbox()
	racer_portrait.rotation = initial_rotation + Vector3(deg_to_rad(pitch_back+pitch_forward), 0, deg_to_rad(pitch_left + pitch_right))
	
func _update_textbox():
	textbox.text = "[color=green]%skm/h[/color]\n[color=yellow]%ss[/color]"%[int(abs(pod_racer.linear_velocity.length())), snappedf(boostmeter.value, 0.01)]
