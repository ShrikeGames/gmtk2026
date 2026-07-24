extends Node

var save_file_location: String = "user://save_data_v1.json"
var CHEVRON_LEFT:String = "⟪"
var CHEVRON_RIGHT:String = "⟫"

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

var track_tiles:Dictionary = {
	"0000": preload("res://assets/game/scenes/road/road_0000.tscn"),
	"0001": preload("res://assets/game/scenes/road/road_0001.tscn"),
	"0010": preload("res://assets/game/scenes/road/road_0010.tscn"),
	"0011": preload("res://assets/game/scenes/road/road_0011.tscn"),
	"0100": preload("res://assets/game/scenes/road/road_0100.tscn"),
	"0110": preload("res://assets/game/scenes/road/road_0110.tscn"),
	"1000": preload("res://assets/game/scenes/road/road_1000.tscn"),
	"1001": preload("res://assets/game/scenes/road/road_1001.tscn"),
	"1100": preload("res://assets/game/scenes/road/road_1100.tscn")
	
}

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
				"Music": 90.0,
				"SFX": 90.0,
				"Voice": 90.0
			}
		}
	},
	"game": {
		"started": false
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
