extends RigidBody2D
class_name Vehicle

@export var initial_planet: Planet
@export var rotation_speed = 90.0 * 2.0

func _ready() -> void:
	self.linear_velocity = initial_planet.initial_velocity

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var planets = get_tree().get_nodes_in_group("planet") as Array[Planet]
	var force = Vector2.ZERO
	
	if Input.is_action_pressed("rotate_left"):
		state.angular_velocity -= deg_to_rad(rotation_speed * state.step)
	if Input.is_action_pressed("rotate_right"):
		state.angular_velocity += deg_to_rad(rotation_speed * state.step)
	
	if Input.is_action_pressed("thrust"):
		var rotated = self.rotation - PI / 2.0
		var direction = Vector2(cos(rotated), sin(rotated))
		force += direction * 120.0
	
	for planet in planets:
		force += Simulation.calculate_force(
			self.mass,
			planet.mass,
			self.position,
			planet.position,
		) * 10.0

	state.linear_velocity += (force / self.mass) * state.step
