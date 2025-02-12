extends State

@export var ui_control: UIControl
@export var game_control: GameControl
@export var simulation: Simulation
@export var camera_2d: Camera2D

func enter(_previous_state: String, data: Dictionary):
	if self.ui_control == null:
		push_error("UI Control missing")
		return
	
	self.simulation.show()
	self.camera_2d.show()
	self.game_control.show()
	self.camera_2d.enabled = true
	
	await self.ui_control.fade_out([self.ui_control], 1)
	self.ui_control.hide()
	
	get_tree().paused = false
	
	print(data)

func physics_update(delta: float):
	if game_control.steering_slider.value > 0.0:
		game_control.steering_slider.value -= 0.1 * delta
	elif game_control.steering_slider.value < 0.0:
		game_control.steering_slider.value += 0.1 * delta
