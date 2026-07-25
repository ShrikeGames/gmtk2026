extends Node3D

@export var pod_racers_node:Node3D
@export var portraits_node:Node3D
@export var speed_hud:SpeedHUD
@export var paths:Array[PathFollow3D]
@export var checkpoint_manager:CheckPointsManager
@export var player_spawn_location:Node3D

var current_camera_index:int = 0

func _ready() -> void:
	current_camera_index = Global.save_data.get("game", {}).get("racer", 0)
	_update()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ChangeCamera"):
		current_camera_index = wrapi(current_camera_index+1, 0, pod_racers_node.get_child_count())
		_update()
		
func _update():
	print(pod_racers_node.get_child(current_camera_index))
	var pod_racer:PodRacer = pod_racers_node.get_child(current_camera_index)
	pod_racer.camera.current = true
	speed_hud.change_racer(pod_racer, portraits_node.get_child(pod_racer.portrait_id))
	for portrait in portraits_node.get_children():
		portrait.visible = false
	portraits_node.get_child(pod_racer.portrait_id).visible = true
