extends Camera3D

@export var pod_racer:PodRacer
@export var fov_shift_strength:float = 20.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.look_at(pod_racer.global_position)
	self.fov = 100 + _get_velocity()
	self.current = pod_racer.player_controlled
	
func _get_velocity() -> float:
	var velocity:float = abs(pod_racer.linear_velocity.length()) / pod_racer.max_velocity
	if velocity < 0.1:
		return 1.0
	return clampf(velocity, 0, 3.0) * fov_shift_strength
