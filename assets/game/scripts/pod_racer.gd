extends RigidBody3D
class_name PodRacer

@export_category("Parts")
@export var jets_node:Node3D

@export_category("Stats")
@export var turn_force:float = 16.0
@export var tilt_force:float = 16.0
@export var max_velocity:float = 40.0

@export_category("Debug")
@export var debug_text:RichTextLabel

var jet_parts:Array[PodRacerJetPart] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for jet_part in jets_node.get_children():
		jet_parts.append(jet_part)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for jet_part in jet_parts:
		if jet_part.visible and jet_part.activation_key in ["Accelerate", "Brake"]:
			if abs(self.linear_velocity.length()) < max_velocity:
				var force:Vector3 = jet_part.ray_cast.global_transform.basis.y.normalized() * jet_part.force_strength
				force.y = 0
				self.apply_central_force(force)
				
		elif jet_part.visible and jet_part.ray_cast.is_colliding():
			var force:Vector3 = jet_part.ray_cast.global_transform.basis.y.normalized() * jet_part.force_strength * max(0, (0.25 * (3.0 - jet_part.collision_distance)))
			self.apply_central_force(force)
		
	if Input.is_action_pressed("Left"):
		self.apply_torque(self.global_basis.x.normalized() * turn_force)
		self.apply_torque(self.global_basis.y.normalized() * tilt_force)
	
	if Input.is_action_pressed("Right"):
		self.apply_torque(-self.global_basis.x.normalized() * turn_force)
		self.apply_torque(-self.global_basis.y.normalized() * tilt_force)
	
	
	debug_text.text = "%s"%[self.linear_velocity]
