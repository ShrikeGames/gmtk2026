extends Camera3D

@export var pod_racer:PodRacer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var target:Vector3 = pod_racer.global_transform.basis.x
	target.y = pod_racer.global_position.y
	self.look_at(pod_racer.global_position + target.normalized() * 3.0)
