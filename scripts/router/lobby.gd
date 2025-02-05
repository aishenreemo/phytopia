extends State

@export var camera_2d: Camera2D

func enter(_previous_state: String) -> void:
	if State.has_null([
		self.camera_2d,
	]):
		return
	
	self.camera_2d.enabled = true
	get_tree().paused = false

func exit() -> void:
	if State.has_null([
		self.camera_2d,
	]):
		return
	
	self.camera_2d.enabled = false
	self.camera_2d.position = Vector2.ZERO
	self.camera_2d.zoom = Vector2.ONE
