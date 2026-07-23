extends MeshInstance3D
class_name PodRacerJetPart

@export var activation_key:String = "Accelerate"
@export var ray_cast:RayCast3D
@export var collision_distance:float = 0.0
@export var force_strength:float = 1.0
@export var applies_torque:bool = false
@export var torque_strength:float = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if activation_key:
		self.visible = Input.is_action_pressed(activation_key) or not activation_key
		
	if ray_cast.is_colliding():
		collision_distance = abs((self.global_position - ray_cast.get_collision_point()).length())
	
