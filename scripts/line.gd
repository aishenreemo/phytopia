extends Line2D
class_name Line

@export var camera: Camera2D

func _physics_process(_delta: float) -> void:
	if self.camera:
		self.width = 1.0 / self.camera.zoom.x
