extends Node

var save_file_location: String = "user://save_data_v1.json"
var CHEVRON_LEFT:String = "{{"
var CHEVRON_RIGHT:String = "}}"

var engine_clips:Array[AudioStream] = [
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_1.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_2.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_3.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_4.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_5.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_6.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_7.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_8.wav"),
]
var engine_boost_clips:Array[AudioStream] = [
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_boost_1.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_boost_2.wav"),
	preload("res://assets/game/audio/sfx/edited/pod_racer_engine_boost_3.wav")
]
var crash_clips:Array[AudioStream] = [
	preload("res://assets/game/audio/sfx/edited/bonk1.wav"),
	preload("res://assets/game/audio/sfx/edited/bonk2.wav"),
	preload("res://assets/game/audio/sfx/edited/bonk3.wav"),
	preload("res://assets/game/audio/sfx/edited/bonk4.wav"),
	preload("res://assets/game/audio/sfx/edited/bonk5.wav"),
	preload("res://assets/game/audio/sfx/edited/bonk6.wav")
]

var flags:Array = [
	preload("res://assets/system/menu/assets/ui/flags/flag1.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag2.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag3.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag4.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag5.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag6.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag7.png"),
	preload("res://assets/system/menu/assets/ui/flags/flag8.png")
	
]
var tracks:Array = [
	preload("res://assets/game/scenes/campaign_track_0.tscn"),
	preload("res://assets/game/scenes/campaign_track_1.tscn"),
	preload("res://assets/game/scenes/campaign_track_2.tscn"),
	preload("res://assets/game/scenes/campaign_track_3.tscn")
]
var days_voicelines:Array = [
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day1.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day2.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day3.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day4.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day5.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day6.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day7.wav"),
	preload("res://assets/game/audio/sfx/edited/voices/narrator_day8.wav")
]
var voice_lines:Array[Dictionary] = [
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_1_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_1_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_1_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_1_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_1_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_1_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_2_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_2_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_2_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_2_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_2_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_2_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_3_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_3_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_3_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_3_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_3_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_3_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_4_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_4_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_4_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_4_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_4_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_4_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_5_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_5_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_5_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_5_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_5_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_5_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_6_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_6_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_6_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_6_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_6_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_6_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_7_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_7_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_7_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_7_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_7_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_7_hit4.wav")
		]
	},
	{
		"pass": preload("res://assets/game/audio/sfx/edited/voices/racer_8_pass.wav"),
		"upset": preload("res://assets/game/audio/sfx/edited/voices/racer_8_upset.wav"),
		"hit": [
			preload("res://assets/game/audio/sfx/edited/voices/racer_8_hit1.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_8_hit2.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_8_hit3.wav"),
			preload("res://assets/game/audio/sfx/edited/voices/racer_8_hit4.wav")
		]
	}
]

var character_unlocks_per_track_win:Array[Array]= [
	[2],
	[3,4],
	[5,6],
	[7]
]

var position_rewards:Array[int] = [5, 3, 1, 0, 0, 0, 0, 0]

var DEFAULT_SAVE_DATA:Dictionary = {
	"settings": {
		"toggles": {
			"difficulty": 1,
			"tutorial": 1,
			"mode": 0,
		},
		"audio": {
			"volume": {
				"Master": 90.0,
				"UI": 90.0,
				"Music": 20.0,
				"SFX": 90.0,
				"Voice": 90.0
			}
		}
	},
	"game": {
		"started": false,
		"unlocked_characters": [true,true,false,false,false,false,false,false],
		"racer": 0,
		"track": 0,
		"total_races": 0,
		"score_history": []
	}
}
var save_data:Dictionary = DEFAULT_SAVE_DATA.duplicate(true)

func read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var json_string = FileAccess.get_file_as_string(path)
	var json_dict = JSON.parse_string(json_string)
	
	return json_dict

func save() -> void:
	var json_string := JSON.stringify(save_data)
	# We will need to open/create a new file for this data string
	var file_access := FileAccess.open(save_file_location, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	file_access.store_line(json_string)
	file_access.close()

func load() -> void:
	var saved_json: Dictionary = read_json(save_file_location)
	if not saved_json.is_empty():
		save_data = saved_json

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
