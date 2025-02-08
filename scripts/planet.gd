@tool
extends RigidBody2D
class_name Planet

@export var surface_gravity = 9.8:
	set(new_surface_gravity):
		surface_gravity = new_surface_gravity
		self.mass = (new_surface_gravity * self.radius * self.radius) / Simulation.G
		
@export var radius = 50.0
@export var initial_velocity: Vector2

func _ready() -> void:
	self.mass = (self.surface_gravity * self.radius * self.radius) / Simulation.G
	self.linear_velocity = self.initial_velocity
	$CollisionShape2D.shape = CircleShape2D.new()
	$CollisionShape2D.shape.radius = self.radius
	
func _integrate_forces(state: PhysicsDirectBodyState2D):
	var planets = get_tree().get_nodes_in_group("planet") as Array[Planet]
	var force = Vector2.ZERO
	
	for planet in planets:
		if self == planet:
			continue
			
		force += Simulation.calculate_force(
			self.mass,
			planet.mass,
			self.position,
			planet.position,
		)
	
	state.linear_velocity += (force / self.mass) * state.step
