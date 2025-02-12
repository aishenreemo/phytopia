extends Node2D
class_name Simulation

@export var prediction_duration = 100.0
@export var prediction = false
@export var camera: Camera2D
const G = 100

func _ready() -> void:
	var planets := get_tree().get_nodes_in_group("planet")
	var trail_scene : PackedScene = load("res://scenes/trail.tscn")
	for i in planets.size():
		var trajectory = Line2D.new()
		var trail = trail_scene.instantiate() as Trail
		trajectory.antialiased = true
		trail.antialiased = true
		trail.planet = planets[i]
		trail.camera = self.camera
		$Trajectories.add_child(trajectory)
		$Trails.add_child(trail)
	
	_on_clock_timeout()

func _physics_process(_delta: float) -> void:
	var planets := get_tree().get_nodes_in_group("planet")
	var trajectories := $Trajectories.get_children()
	
	if trajectories.size() != planets.size():
		push_error("Trajectory and planets size mismatch.")
		return
		
	for i in planets.size():
		for point in (trajectories[i] as Line2D).points:
			if point.distance_to(planets[i].position) >= planets[i].radius:
				break
			(trajectories[i] as Line2D).remove_point(0)

func _input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	if event is InputEventKey:
		if !event.pressed:
			return
		if event.keycode == KEY_1:
			Engine.time_scale = 1.0
		elif event.keycode == KEY_EQUAL:
			Engine.time_scale *= 2.0
		elif event.keycode == KEY_MINUS:
			Engine.time_scale /= 2.0
		elif event.keycode == KEY_G:
			self.prediction = !self.prediction
			_on_clock_timeout()
		
		if Engine.time_scale > 2.0 - 0.1:
			self.prediction = false

static func calculate_force(
	mass_a: float,
	mass_b: float,
	pos_a: Vector2,
	pos_b: Vector2,
) -> Vector2:
	var distance_sqrd = max(pos_b.distance_squared_to(pos_a), 0.0000001)
	var direction = (pos_b - pos_a).normalized()
	return direction * ((Simulation.G * mass_b * mass_a) / distance_sqrd)

func _on_clock_timeout() -> void:
	if !self.prediction:
		return
		
	var delta = 1.0 / Engine.physics_ticks_per_second
	var planets = get_tree().get_nodes_in_group("planet")
	var trajectories = $Trajectories.get_children()
	var current_duration = 0.0
	var positions = []
	var velocities = []
	
	for i in planets.size():
		trajectories[i].clear_points()
		positions.push_back(planets[i].position)
		velocities.push_back(planets[i].linear_velocity)

	while current_duration < self.prediction_duration:
		for i in planets.size():
			var force = Vector2.ZERO
			for j in planets.size():
				if i == j:
					continue
				force += Simulation.calculate_force(
					planets[i].mass,
					planets[j].mass,
					positions[i],
					positions[j],
				)
			
			if planets[i].freeze:
				continue
			
			velocities[i] += (force / planets[i].mass) * delta
			positions[i] += velocities[i] * delta
			trajectories[i].add_point(positions[i])
		
		current_duration += delta
