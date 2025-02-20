extends Node2D
class_name Simulation

@export var camera: Camera2D
const G = 100

func _ready() -> void:
	var planets := get_tree().get_nodes_in_group("planet")
	var line_scene: PackedScene = load("res://scenes/line.tscn")
	
	for i in planets.size():
		var other_planets = planets[i].orbit_to
		if other_planets.size() != 2:
			continue
		
		for op in other_planets:
			if op.name != "Sun":
				planets[i].position -= op.position

	for i in planets.size():
		var line = line_scene.instantiate() as Line
		line.antialiased = true
		line.antialiased = true
		line.camera = self.camera
		line.modulate.a = 0.25
		$Trajectories.add_child(line)

		var other_planets = planets[i].orbit_to
		
		if other_planets.size() != 1:
			continue

		if other_planets[0].name != "Sun":
			continue

		var p_1 = planets[i]
		var p_2 = other_planets[0]
		var x_1 = p_1.position
		var x_2 = p_2.position
		
		var r = x_1 - x_2
		var distance = r.length()
		var v = sqrt(Simulation.G * p_2.mass / distance)
		var period = (2 * PI * distance) / v
		var omega = 2 * PI / period
		var theta_initial = atan2(r.y, r.x)
		var current_time = 0.0
		var delta = period / 200.0
		
		while current_time <= period + delta:
			var theta = theta_initial + omega * current_time
			var point = Vector2(distance * cos(theta), distance * sin(theta))
			line.add_point(point)
			current_time += delta
		
		var random_number = randi_range(0, 200)
		var random_position = line.get_point_position(random_number)
		p_1.position = random_position
		p_1.linear_velocity = Vector2(-p_1.position.y * omega, p_1.position.x * omega)
		
	for i in planets.size():
		var other_planets = planets[i].orbit_to
		if other_planets.size() != 2:
			continue
		var moon = planets[i]
		var sun = other_planets.filter(func(p): return p.name == "Sun")[0]
		var planet = other_planets.filter(func(p): return p.name != "Sun")[0]
			
		var M_p = planet.mass
		
		var direction = (planet.position - sun.position).normalized()
		moon.position = moon.position.length() * direction
		moon.position += planet.position
		
		var R_m = moon.position.distance_to(planet.position)

		var v_m = sqrt(G * M_p / R_m)

		var moon_velocity_relative_direction = (moon.position - planet.position).normalized().rotated(PI / 2)
		var moon_velocity_relative = moon_velocity_relative_direction * v_m
		moon.linear_velocity = planet.linear_velocity + moon_velocity_relative
		
func _physics_process(_delta: float) -> void:
	pass

static func calculate_force(
	mass_a: float,
	mass_b: float,
	pos_a: Vector2,
	pos_b: Vector2,
) -> Vector2:
	var distance_sqrd = max(pos_b.distance_squared_to(pos_a), 0.0000001)
	var direction = (pos_b - pos_a).normalized()
	return direction * ((Simulation.G * mass_b * mass_a) / distance_sqrd)
