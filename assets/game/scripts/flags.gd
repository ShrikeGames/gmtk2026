extends Node2D
class_name Flags
var checkpoint_manager:CheckPointsManager

func set_checkpoint_manager(new_checkpoint_manager:CheckPointsManager):
	self.checkpoint_manager = new_checkpoint_manager
	checkpoint_manager.positions_changed.connect(_positions_changed)

func _positions_changed():
	if not checkpoint_manager:
		return
	
	for i in range(0, min(self.get_child_count(), len(checkpoint_manager.pod_racers))):
		var pod_racer:PodRacer = checkpoint_manager.pod_racers[i]
		var flag_sprite:Sprite2D = self.get_child(i)
		flag_sprite.texture = Global.flags[pod_racer.portrait_id]
		flag_sprite.visible = true
