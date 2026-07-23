extends RichTextLabel

@export var slider:HSlider
@export var audio_stream_player:AudioStreamPlayer
@export var audio_bus_name:String = "Master"
@export var chevrons:Node2D
var audio_playback:AudioStreamPlaybackInteractive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_prepare_audio()
	slider.value_changed.connect(_slider_value_changed)
	Global.load()
	slider.value = Global.save_data.get("settings", {}).get("audio", {}).get("volume", {}).get(audio_bus_name, slider.max_value)
	chevrons.visible = false

func _prepare_audio() -> void:
	var audio_stream_player_stream = preload("res://assets/system/menu/assets/ui/sfx/ui_button_sounds.tres")
	audio_stream_player.stream = audio_stream_player_stream
	audio_stream_player.play()
	audio_playback = self.audio_stream_player.get_stream_playback() as AudioStreamPlaybackInteractive

func _slider_value_changed(value: float) -> void:
	self.audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_playback.switch_to_clip_by_name("Click")
	var audio_bus_index = AudioServer.get_bus_index(audio_bus_name)
	update_volume(audio_bus_index, value)



func update_volume(audio_bus_index: int, linear_value: float):
	Global.save_data.get("settings", {}).get("audio", {}).get("volume", {}).set(audio_bus_name, linear_value)
	Global.save()
	var volume_db = 20 * (log(linear_value * 0.01) / log(10))
	AudioServer.set_bus_volume_db(audio_bus_index, volume_db)


func _on_volume_slider_mouse_entered() -> void:
	self.audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_playback.switch_to_clip_by_name("Hover")
	chevrons.visible = true


func _on_volume_slider_mouse_exited() -> void:
	chevrons.visible = false
