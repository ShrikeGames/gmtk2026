extends AudioStreamPlayer3D

class_name PodRacerEngineSFXPlayer

@export var pod_racer:PodRacer

@export_category("Audio")
@export var min_pitch:float = 0.8
@export var max_pitch:float = 1.5
@export var pitch_responsiveness:float = 6.0
@export var clips:Array[AudioStream] = Global.engine_clips

func _ready() -> void:
	finished.connect(_play_random_clip)
	pod_racer.boost.connect(_pod_racer_boost)
	_play_random_clip()

func _pod_racer_boost(pressed:bool):
	if pressed:
		clips = Global.engine_boost_clips
	else:
		clips = Global.engine_clips
	_play_random_clip()

func _process(delta: float) -> void:
	var target_pitch:float = lerpf(min_pitch, max_pitch, _get_velocity())
	self.pitch_scale = lerpf(self.pitch_scale, target_pitch, min(1.0, pitch_responsiveness * delta))

func _play_random_clip() -> void:
	self.stream = clips.pick_random()
	self.play()
	if clips != Global.engine_clips:
		clips = Global.engine_clips

func _get_velocity() -> float:
	var velocity:float = abs(pod_racer.linear_velocity.length())
	if velocity < 0.1:
		return 0.0
	return clampf(velocity / pod_racer.max_velocity, 0.0, 1.0)
