extends Button

class_name MainMenuButton
@export var audio_stream_player:AudioStreamPlayer
var audio_playback:AudioStreamPlaybackInteractive
var original_text:String
@export var add_chevrons:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_prepare_audio()
	original_text = self.text
	

func _prepare_audio() -> void:
	var audio_stream_player_stream = preload("res://assets/system/menu/assets/ui/sfx/ui_button_sounds.tres")
	audio_stream_player.stream = audio_stream_player_stream
	audio_stream_player.play()
	audio_playback = self.audio_stream_player.get_stream_playback() as AudioStreamPlaybackInteractive

func _on_mouse_entered() -> void:
	update_text(add_chevrons)
	self.audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_playback.switch_to_clip_by_name("Hover")
	self.scale = Vector2(1.1,1.1)


func _on_mouse_exited() -> void:
	update_text(false)
	self.scale = Vector2(1.0,1.0)


func _on_button_down() -> void:
	update_text(add_chevrons)
	self.audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
	audio_playback.switch_to_clip_by_name("Click")
	self.scale = Vector2(1.1,1.1)

func update_text(include_chevrons:bool) -> void:
	if include_chevrons:
		self.text = "%s %s %s"%[Global.CHEVRON_LEFT, original_text, Global.CHEVRON_RIGHT]
	else:
		self.text = "%s"%[original_text]
