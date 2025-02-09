extends Line2D
class_name Trail

@export var point_spacing: float = 100.0
@export var planet: Planet
@export var camera: Camera2D

var distance_accum: float = 0.0

func _ready():
	self.clear_points()

func _physics_process(delta: float) -> void:
	if self.planet == null:
		return
	
	if self.camera:
		self.width = 1.0 / self.camera.zoom.x
		
	if self.get_point_count() == 0:
		self.add_point(planet.position)
	
	var last_point = self.get_point_position(self.get_point_count() - 1)
	var distance = planet.position.distance_to(last_point)
	distance_accum += distance
	
	if distance_accum >= point_spacing:
		self.add_point(planet.position)
		distance_accum = 0.0
