extends MeshInstance3D
class_name PodRacerJetPart

@export var activation_key:String = "Accelerate"
@export var ray_cast:RayCast3D
@export var collision_distance:float = 0.0
@export var force_strength:float = 1.0
@export var applies_torque:bool = false
@export var torque_strength:float = 3.0
@export var activated:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.visible = activated or not activation_key
		
	if ray_cast.is_colliding():
		collision_distance = abs((self.global_position - ray_cast.get_collision_point()).length())
	
func activate_jet(enable:bool):
	activated = enable
