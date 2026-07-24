extends Node2D

@export var pod_racer:PodRacer
@export var speedmeter:TextureProgressBar
@export var boostmeter:TextureProgressBar
@export var textbox:RichTextLabel
@export var racer_portrait:Node3D
var initial_rotation:Vector3

var pitch_right:float = 0
var pitch_left:float = 0
var pitch_forward:float = 0
var pitch_back:float = 0

func _ready() -> void:
	speedmeter.max_value = pod_racer.max_velocity
	boostmeter.max_value = pod_racer.max_boost
	
	initial_rotation = racer_portrait.rotation
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
	speedmeter.value = clampf(0.0, abs(pod_racer.linear_velocity.length()), pod_racer.max_velocity)
	boostmeter.value = clampf(0.0, pod_racer.current_boost, pod_racer.max_boost)
	_update_textbox()
	racer_portrait.rotation = initial_rotation + Vector3(deg_to_rad(pitch_back+pitch_forward), 0, deg_to_rad(pitch_left + pitch_right))
	
func _update_textbox():
	textbox.text = "[color=green]%skm/h[/color]\n[color=yellow]%ss[/color]"%[snappedf(abs(pod_racer.linear_velocity.length()), 0.01), snappedf(boostmeter.value, 0.01)]
