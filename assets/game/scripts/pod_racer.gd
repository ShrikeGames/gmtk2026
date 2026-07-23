extends RigidBody3D
class_name PodRacer

@export_category("Parts")
@export var jets_node: Node3D

@export_category("Stats")
@export var turn_force: float = 16.0
@export var tilt_force: float = 16.0
@export var max_velocity: float = 120.0

@export_category("Jank")
@export var upright_strength: float = 40.0
@export var local_up_axis: Vector3 = Vector3(1, 0, 0)
@export var slide_along_walls: bool = true

@export_category("Hover")
@export var hover_range: float = 1.5
@export var hover_stiffness: float = 0.5

@export_category("Debug")
@export var debug_text: RichTextLabel

var jet_parts: Array[PodRacerJetPart] = []
var wall_normals: Array[Vector3] = []

func _ready() -> void:
	for jet_part in jets_node.get_children():
		jet_parts.append(jet_part)

func _process(_delta: float) -> void:
	if debug_text:
		debug_text.text = "%s" % [self.linear_velocity]

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	wall_normals.clear()
	for i in state.get_contact_count():
		var away: Vector3 = global_position - state.get_contact_local_position(i)
		away.y = 0.0
		if away.length() > 0.05:
			wall_normals.append(away.normalized())

func _slide_thrust(force: Vector3) -> Vector3:
	if not slide_along_walls:
		return force
	for n in wall_normals:
		var into: float = force.dot(-n)
		if into > 0.0:
			force += n * into
	return force

func _physics_process(_delta: float) -> void:
	for jet_part in jet_parts:
		if jet_part.visible and jet_part.activation_key in ["Accelerate", "Brake"]:
			if abs(self.linear_velocity.length()) < max_velocity:
				var force: Vector3 = jet_part.ray_cast.global_transform.basis.y.normalized() * jet_part.force_strength
				force.y = 0
				force = _slide_thrust(force)
				self.apply_central_force(force)

		elif jet_part.visible and jet_part.ray_cast.is_colliding():
			var force: Vector3 = jet_part.ray_cast.global_transform.basis.y.normalized() * jet_part.force_strength * max(0, (hover_stiffness * (hover_range - jet_part.collision_distance)))
			self.apply_central_force(force)

	if Input.is_action_pressed("Left"):
		self.apply_torque(self.global_basis.x.normalized() * turn_force)
		self.apply_torque(self.global_basis.y.normalized() * tilt_force)

	if Input.is_action_pressed("Right"):
		self.apply_torque(-self.global_basis.x.normalized() * turn_force)
		self.apply_torque(-self.global_basis.y.normalized() * tilt_force)

	_apply_upright_torque()

func _apply_upright_torque() -> void:
	if upright_strength <= 0.0:
		return
	var up: Vector3 = (global_basis * local_up_axis).normalized()
	var correction: Vector3 = up.cross(Vector3.UP)
	apply_torque(correction * upright_strength)
