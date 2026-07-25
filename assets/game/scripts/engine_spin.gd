extends MeshInstance3D

@export var pod_racer:PodRacer

func _process(delta: float) -> void:
	self.rotate_y((5.0*abs(pod_racer.linear_velocity.length())/pod_racer.max_velocity)* delta)
