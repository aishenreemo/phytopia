extends RigidBody2D
class_name Vehicle

@export var initial_planet: Planet
@export var rotation_speed = 90.0 * 2.0
@export var fire: Sprite2D
@export var camera: Camera2D

var force_multiplier: float = 30.0
var current_tween: Tween = null

func _ready() -> void:
	await get_parent().ready
	self.position = self.initial_planet.position
	self.position.y -= self.initial_planet.radius
	self.linear_velocity = self.initial_planet.linear_velocity
	self.fire.hide()
	$Placeholder/FireScalable.hide()

func _physics_process(_delta: float) -> void:
	if self.camera == null:
		return
	
	if self.current_tween:
		self.current_tween.kill()
		self.current_tween = null
		
	self.current_tween = self.create_tween()
	self.current_tween.set_ease(Tween.EASE_IN_OUT)
	self.current_tween.set_trans(Tween.TRANS_SINE)
	self.current_tween.set_parallel(true)
	
	var alpha = float(self.camera.zoom.x < (1.0 / 8.0))
	var polygon_scale = (1.0 / 64.0) * Vector2.ONE / self.camera.zoom.x
	
	self.current_tween.tween_property($Placeholder, "modulate:a", alpha, 0.1)
	self.current_tween.tween_property($Placeholder, "scale", polygon_scale, 0.1)
	
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
		force = direction * self.force_multiplier
		self.fire.show()
		$Placeholder/FireScalable.show()
		
	if Input.is_action_just_released("thrust"):
		self.fire.hide()
		$Placeholder/FireScalable.hide()
	
	for planet in planets:
		force += Simulation.calculate_force(
			self.mass,
			planet.mass,
			self.position,
			planet.position,
		) * 10.0

	state.linear_velocity += (force / self.mass) * state.step

func _on_game_control_gear_value_changed(value: float) -> void:
	var multipliers = [0, 30, 100, 500, 1000, 3000, 6000]
	self.force_multiplier = multipliers[int(value)]
