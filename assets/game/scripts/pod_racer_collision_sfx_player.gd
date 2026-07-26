extends AudioStreamPlayer3D

class_name PodRacerCollisionSFXPlayer

@export var pod_racer:PodRacer
@export_category("Audio")
@export var min_pitch:float = 0.8
@export var max_pitch:float = 1.5
@export var pitch_responsiveness:float = 6.0
@export var clips:Array[AudioStream] = Global.crash_clips
var can_play_clip:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clips = Global.crash_clips
	pod_racer.crash.connect(_pod_racer_crash)
	finished.connect(_clip_finished)

func _clip_finished() -> void:
	can_play_clip = true

func _pod_racer_crash():
	_play_random_clip()

func _play_random_clip() -> void:
	if not can_play_clip:
		return
	can_play_clip = false
	self.stream = clips.pick_random()
	var target_pitch:float = lerpf(min_pitch, max_pitch, _get_velocity())
	self.pitch_scale = lerpf(self.pitch_scale, target_pitch, min(1.0, pitch_responsiveness))
	self.play()
	pod_racer.take_damage(10)

func _get_velocity() -> float:
	var velocity:float = abs(pod_racer.linear_velocity.length())
	if velocity < 0.1:
		return 0.0
	return clampf(velocity / pod_racer.max_velocity, 0.0, 1.0)
