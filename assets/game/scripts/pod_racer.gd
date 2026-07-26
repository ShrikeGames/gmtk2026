extends RigidBody3D
class_name PodRacer

signal accelerate
signal brake
signal boost
signal crash
signal left
signal right
@export_category("Controls")
@export var player_controlled: bool = false
@export var camera: Camera3D

@export_category("CPU")
@export var path_follow: PathFollow3D
## larger = smoother and better
@export var cpu_lookahead: float = 100.0
## has to be above this angle (rad) to steer
@export var cpu_steer_deadzone: float = 0.05
## if above this angle will full steer
@export var cpu_full_steer_angle: float = 0.2
## too sharp of a turn so brake
@export var cpu_brake_angle: float = 0.3
## boost on straight aways
@export var cpu_boost_angle: float = 0.15
var is_boosting: bool = false
var boost_active: bool = false
var boost_latched: bool = false
var cpu_accelerating: bool = false
var cpu_braking: bool = false
var cpu_boosting: bool = false
var cpu_left: bool = false
var cpu_right: bool = false

@export_category("Parts")
@export var jets_node: Node3D
@export var portrait_id: int = 0

@export_category("Stats")
@export var racer_name: String = "Echo"
@export var turn_force: float = 16.0
@export var tilt_force: float = 16.0
@export var max_velocity: float = 260.0
@export var max_boost: float = 2.0
@export var health: float = 100.0
@export var max_health: float = 100.0
var current_boost: float = 2.0
var checkpoint_position: Vector3
var checkpoint_rotation: Vector3

@export_category("Jank")
@export var upright_strength: float = 60.0
@export var local_up_axis: Vector3 = Vector3(1, 0, 0)
@export var slide_along_walls: bool = true

@export_category("Hover")
@export var hover_range: float = 2.5
@export var hover_stiffness: float = 0.75

@export_category("Lap Progress")
@export var current_checkpoint: int = -1
@export var current_lap: int = 0

@export_category("Debug")
@export var disabled: bool = true
@export var debug_text: RichTextLabel

@export_category("Voice")
@export var voice_player: AudioStreamPlayer3D
@export var min_pitch: float = 0.9
@export var max_pitch: float = 1.1
@export var pitch_responsiveness: float = 6.0
@export var clips_dict: Dictionary
@export var last_position: int = portrait_id
var can_play_voice_clip: bool = true

var jet_parts: Array[PodRacerJetPart] = []
var wall_normals: Array[Vector3] = []


# Reference thrust jet, used to derive which way the pod actually faces.
var accelerate_jet: PodRacerJetPart = null
var difficulty_modifer: float = 1.0
var is_journalist: bool = false
func _ready() -> void:
	self.clips_dict = Global.voice_lines[portrait_id]
	difficulty_modifer = Global.save_data.get("settings", {}).get("toggles", {}).get("difficulty", 0)
	if Global.save_data.get("game", {}).get("racer", 0) == portrait_id:
		if difficulty_modifer > 0.0:
			self.player_controlled = true
		else:
			self.is_journalist = true
		
		self.camera.current = true
	
	for jet_part in jets_node.get_children():
		if jet_part.activation_key in ["Accelerate"]:
			accelerate.connect(jet_part.activate_jet)
			if accelerate_jet == null:
				accelerate_jet = jet_part
		elif jet_part.activation_key in ["Brake"]:
			brake.connect(jet_part.activate_jet)
		elif jet_part.activation_key in ["Boost"]:
			boost.connect(jet_part.activate_jet)
		jet_parts.append(jet_part)
	
	if self.voice_player:
		self.voice_player.finished.connect(_clip_finished)
		self.crash.connect(_play_random_hit_voiceline)


func _clip_finished() -> void:
	can_play_voice_clip = true

func _play_random_hit_voiceline() -> void:
	if not can_play_voice_clip or not self.voice_player:
		return
	can_play_voice_clip = false
	self.voice_player.stream = clips_dict.get("hit").pick_random()
	var target_pitch: float = lerpf(min_pitch, max_pitch, get_velocity())
	self.voice_player.pitch_scale = lerpf(self.voice_player.pitch_scale, target_pitch, min(1.0, pitch_responsiveness))
	self.voice_player.play()

func play_pass_voiceline() -> void:
	if not can_play_voice_clip or not self.voice_player:
		return
	can_play_voice_clip = false
	self.voice_player.stream = clips_dict.get("pass")
	var target_pitch: float = lerpf(min_pitch, max_pitch, get_velocity())
	self.voice_player.pitch_scale = lerpf(self.voice_player.pitch_scale, target_pitch, min(1.0, pitch_responsiveness))
	self.voice_player.play()

func play_upset_voiceline() -> void:
	if not can_play_voice_clip or not self.voice_player:
		return
	can_play_voice_clip = false
	self.voice_player.stream = clips_dict.get("upset")
	var target_pitch: float = lerpf(min_pitch, max_pitch, get_velocity())
	self.voice_player.pitch_scale = lerpf(self.voice_player.pitch_scale, target_pitch, min(1.0, pitch_responsiveness))
	self.voice_player.play()

func get_velocity() -> float:
	var velocity: float = abs(self.linear_velocity.length())
	if velocity < 0.1:
		return 0.0
	return clampf(velocity / self.max_velocity, 0.0, 1.0)

func take_damage(damage: float):
	#health = max(0, health-damage)
	_play_random_hit_voiceline()
	if health <= 0:
		self._respawn()

func _respawn():
	print(self.racer_name, " respawned at ", checkpoint_position)
	health = max_health
	linear_velocity = Vector3.ZERO
	self.global_position = checkpoint_position
	self.global_rotation = checkpoint_rotation

func _process(_delta: float) -> void:
	if self.global_position.y <= -10:
		_respawn()
	if debug_text:
		debug_text.text = "%s %s %s" % [self.linear_velocity, abs(self.linear_velocity.length()), self.current_boost]

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
			crash.emit()
	return force

func _physics_process(delta: float) -> void:
	# Controls run first so jet activation and is_boosting are fresh this tick.
	if player_controlled:
		_apply_player_controls(delta)
	else:
		_apply_cpu_controls(delta)
	
	for jet_part in jet_parts:
		if jet_part.visible and jet_part.activation_key in ["Accelerate", "Brake", "Boost"]:
			if disabled:
				return
			if abs(self.linear_velocity.length()) < max_velocity:
				var force: Vector3 = jet_part.ray_cast.global_transform.basis.y.normalized() * jet_part.force_strength
				force.y = 0
				if not player_controlled and not is_journalist:
					## nerf less with higher difficulties
					var modifier: float = 0.9 - (0.4 - (difficulty_modifer * 0.1))
					force *= modifier
				force = _slide_thrust(force)
				self.apply_central_force(force)

		elif jet_part.visible and jet_part.ray_cast.is_colliding():
			var force: Vector3 = jet_part.ray_cast.global_transform.basis.y.normalized() * jet_part.force_strength * max(0, (hover_stiffness * (hover_range - jet_part.collision_distance)))
			self.apply_central_force(force)
	if disabled:
		self.linear_velocity.x = 0
		self.linear_velocity.z = 0
		
	_apply_upright_torque()

func _apply_upright_torque() -> void:
	if upright_strength <= 0.0:
		return
	var up: Vector3 = (global_basis * local_up_axis).normalized()
	var correction: Vector3 = up.cross(Vector3.UP)
	apply_torque(correction * upright_strength)

# True when a fresh boost is allowed to begin: the meter must be completely full.
func is_boost_ready() -> bool:
	return current_boost >= max_boost

func _update_boost(wants_boost: bool, delta: float) -> bool:
	if boost_active:
		# Keep going only while still asked for and there's charge left.
		boost_active = wants_boost and current_boost > 0.0
	elif wants_boost and is_boost_ready():
		boost_active = true

	if boost_active:
		current_boost = clampf(current_boost - delta, 0.0, max_boost)
		if current_boost <= 0.0:
			boost_active = false
	elif current_boost < max_boost:
		current_boost = clampf(current_boost + delta, 0.0, max_boost)

	boost_latched = _latch(boost_latched, boost_active, boost)
	is_boosting = boost_active
	return boost_active

# Emits `sig` only when the state actually changes, mirroring the player's
# just_pressed / just_released behaviour. Returns the new state.
func _latch(current: bool, desired: bool, sig: Signal) -> bool:
	if current != desired:
		sig.emit(desired)
	return desired

# The direction the pod actually accelerates in, flattened to the horizontal
# plane. Derived from the thrust jet so it can't disagree with the physics.
func _get_forward() -> Vector3:
	if accelerate_jet != null and accelerate_jet.ray_cast != null:
		var f: Vector3 = accelerate_jet.ray_cast.global_transform.basis.y
		f.y = 0.0
		if f.length() > 0.001:
			return f.normalized()
	# Fall back to travel direction if the jet isn't usable yet.
	var v: Vector3 = linear_velocity
	v.y = 0.0
	if v.length() > 0.1:
		return v.normalized()
	return -global_basis.z

# Slides the PathFollow3D to sit `cpu_lookahead` ahead of wherever the pod
# currently is on the curve, so the aim point tracks us instead of drifting.
func _update_path_target() -> void:
	var path: Path3D = path_follow.get_parent() as Path3D
	if path == null or path.curve == null:
		return
	var path_scale: float = path.global_basis.get_scale().x
	if path_scale <= 0.0001:
		path_scale = 1.0
	var closest_offset: float = path.curve.get_closest_offset(path.to_local(global_position))
	path_follow.progress = closest_offset + cpu_lookahead / path_scale

func _apply_cpu_controls(delta: float) -> void:
	if disabled:
		return
	
	if path_follow == null:
		return
		
	_update_path_target()
	
	var to_target: Vector3 = path_follow.global_position - global_position
	to_target.y = 0.0
	if to_target.length() < 0.001:
		return
	to_target = to_target.normalized()

	var steer_angle: float = _get_forward().signed_angle_to(to_target, Vector3.UP)
	var abs_angle: float = absf(steer_angle)
	
	var want_left: bool = steer_angle > cpu_steer_deadzone
	var want_right: bool = steer_angle < -cpu_steer_deadzone
	var want_brake: bool = abs_angle > cpu_brake_angle and abs(linear_velocity.length()) > max_velocity * 0.4
	var want_accel: bool = not want_brake
	var want_boost: bool = abs_angle < cpu_boost_angle and not want_brake

	cpu_left = _latch(cpu_left, want_left, left)
	cpu_right = _latch(cpu_right, want_right, right)
	cpu_accelerating = _latch(cpu_accelerating, want_accel, accelerate)
	cpu_braking = _latch(cpu_braking, want_brake, brake)

	cpu_boosting = _update_boost(want_boost, delta)


	if want_left or want_right:
		var steer_strength: float = clampf(abs_angle / cpu_full_steer_angle, 0.0, 1.0)
		var steer_dir: float = 1.0 if want_left else -1.0
		apply_torque(global_basis.x.normalized() * turn_force * steer_strength * steer_dir)
		apply_torque(global_basis.y.normalized() * tilt_force * steer_strength * steer_dir)

func _apply_player_controls(delta: float) -> void:
	if Input.is_action_just_pressed("Accelerate"):
		accelerate.emit(true)
	elif Input.is_action_just_released("Accelerate"):
		accelerate.emit(false)
	
	if Input.is_action_just_pressed("Brake"):
		brake.emit(true)
	elif Input.is_action_just_released("Brake"):
		brake.emit(false)
		
	if Input.is_action_just_pressed("Right"):
		right.emit(true)
	elif Input.is_action_just_released("Right"):
		right.emit(false)
	
	if Input.is_action_just_pressed("Left"):
		left.emit(true)
	elif Input.is_action_just_released("Left"):
		left.emit(false)
	
	_update_boost(Input.is_action_pressed("Boost"), delta)
	
	if Input.is_action_pressed("Left"):
		self.apply_torque(self.global_basis.x.normalized() * turn_force)
		self.apply_torque(self.global_basis.y.normalized() * tilt_force)

	if Input.is_action_pressed("Right"):
		self.apply_torque(-self.global_basis.x.normalized() * turn_force)
		self.apply_torque(-self.global_basis.y.normalized() * tilt_force)
