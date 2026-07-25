extends Node3D

class_name TrackManager

@export var pod_racers_node:Node3D
@export var portraits_node:Node3D
@export var speed_hud:SpeedHUD
@export var flags_node:Flags

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var track_id:int = int(Global.save_data.get("game", {}).get("track", 0))
	print("track_id: ", track_id)
	var track_resource = Global.tracks[track_id].instantiate()
	track_resource.pod_racers_node = pod_racers_node
	track_resource.portraits_node = portraits_node
	track_resource.speed_hud = speed_hud
	self.add_child(track_resource)
	pod_racers_node.global_position = track_resource.player_spawn_location.global_position
	flags_node.set_checkpoint_manager(track_resource.checkpoint_manager)
	
	for pod_racer in pod_racers_node.get_children():
		pod_racer.path_follow = track_resource.paths.pick_random()
	
