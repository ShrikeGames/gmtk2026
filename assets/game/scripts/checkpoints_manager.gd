extends Node3D

class_name CheckPointsManager
signal positions_changed

var pod_racers_node:Node3D
@export var max_laps:int = 3
var pod_racers:Array[PodRacer] = []
var total_checkpoints:int
var campaign_menu_scene:String = "res://assets/system/menu/scenes/campaign_menu.tscn"
var track

func _ready() -> void:
	track = get_parent()
	pod_racers_node = track.pod_racers_node
	for pod_racer in pod_racers_node.get_children():
		var unlocked_characters:Array = Global.save_data.get("game", {}).get("unlocked_characters", [true,true,false,false,false,false,false,false])
		if unlocked_characters[pod_racer.portrait_id] or pod_racer.portrait_id in Global.character_unlocks_per_track_win[Global.save_data.get("game",{}).get("track", 0)]:
			pod_racers.append(pod_racer as PodRacer)
	for checkpoint in self.get_children():
		checkpoint.checkpoint_reached.connect(_checkpoint_reached)
	total_checkpoints = self.get_child_count()

func _checkpoint_reached(body:Node3D, checkpoint_id:int):
	if body in pod_racers:
		#print(body.racer_name, ": ", body.current_checkpoint, " ? ", checkpoint_id)
		if body.current_checkpoint == checkpoint_id-1 or (body.current_checkpoint == total_checkpoints-1 and checkpoint_id == 0):
			body.current_checkpoint = checkpoint_id
			body.checkpoint_position = self.get_child(checkpoint_id).global_position
			body.checkpoint_rotation = self.get_child(checkpoint_id).global_rotation
			
			if body.current_checkpoint == 0:
				#print(body.racer_name, " completed lap ", body.current_lap)
				body.current_lap += 1
				body.path_follow = track.paths.pick_random()
				# change scenes
			# print(body.racer_name, " reached checkpoint ", checkpoint_id)
			_update_race_positions()
			
func _update_race_positions():
	pod_racers.sort_custom(sort_by_position)
	positions_changed.emit()
	var racer_position:int = 0
	for body in pod_racers:
		if racer_position < body.last_position:
			body.play_pass_voiceline()
		elif racer_position > body.last_position:
			body.play_upset_voiceline()
		body.last_position = racer_position
		if body.current_lap > max_laps:
			if body.player_controlled or body.is_journalist:
				# award points
				var points:int = Global.save_data.get("game", {}).get("points", 0)
				Global.save_data.get("game", {}).set("points", points + Global.position_rewards[racer_position])
				var total_races:int = Global.save_data.get("game", {}).get("total_races", 0)
				Global.save_data.get("game", {}).set("total_races", total_races + 1)
				var score_history:Array = Global.save_data.get("game", {}).get("score_history", [])
				score_history.append( Global.position_rewards[racer_position])
				Global.save_data.get("game", {}).set("score_history", score_history)
				if racer_position == 0:
					var unlocked_characters:Array = Global.save_data.get("game", {}).get("unlocked_characters", [true,true,false,false,false,false,false,false])
					for char_id in Global.character_unlocks_per_track_win[Global.save_data.get("game",{}).get("track", 0)]:
						unlocked_characters[char_id] = true
					Global.save_data.get("game", {}).set("unlocked_characters", unlocked_characters)
				Global.save()
				get_tree().change_scene_to_file(campaign_menu_scene)
			else:
				body.disabled = true
		racer_position += 1
	
func sort_by_position(a:PodRacer, b:PodRacer):
	if a.current_lap > b.current_lap:
		return true
	if a.current_lap < b.current_lap:
		return false
	if a.current_lap == b.current_lap:
		if a.current_checkpoint > b.current_checkpoint:
			return true
	return false
