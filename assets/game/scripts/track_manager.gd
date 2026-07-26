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
	pod_racers_node.global_position = track_resource.player_spawn_location.global_position + Vector3(0,3,0)
	pod_racers_node.global_rotation = track_resource.player_spawn_location.global_rotation
	for pod_racer in pod_racers_node.get_children():
		pod_racer.checkpoint_position = pod_racers_node.global_position + Vector3(0,3,0)
		pod_racer.checkpoint_rotation = pod_racer.global_rotation
	
	flags_node.set_checkpoint_manager(track_resource.checkpoint_manager)
	
	for pod_racer in pod_racers_node.get_children():
		pod_racer.path_follow = track_resource.paths.pick_random()
		var unlocked_characters:Array = Global.save_data.get("game", {}).get("unlocked_characters", [true,true,false,false,false,false,false,false])
		if not unlocked_characters[pod_racer.portrait_id] and not pod_racer.portrait_id in Global.character_unlocks_per_track_win[Global.save_data.get("game",{}).get("track", 0)]:
			pod_racer.get_parent().remove_child(pod_racer)
