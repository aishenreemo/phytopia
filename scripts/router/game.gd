extends State

@export var galaxy_texture: TextureRect
@export var ui_control: UIControl
@export var game_control: GameControl
@export var simulation: Simulation
@export var camera_2d: Camera2D

func enter(_previous_state: String, _data: Dictionary):
	if self.ui_control == null:
		push_error("UI Control missing")
		return
	
	self.simulation.show()
	
	self.camera_2d.show()
	self.galaxy_texture.show()
	self.camera_2d.enabled = true
	
	await self.ui_control.fade_out([self.ui_control], 1)
	self.ui_control.hide()
	self.game_control.show()
	
	get_tree().paused = false

func exit(_next_state: String):
	self.galaxy_texture.hide()
