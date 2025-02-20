extends State

@export var galaxy_texture: TextureRect
@export var ui_control: UIControl
@export var game_control: GameControl
@export var simulation: Simulation
@export var camera_2d: Camera2D

var feet_count: int = 0

func enter(_previous_state: String, data: Dictionary):
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
	
	var planets = get_tree().get_nodes_in_group("planet")
	for planet in planets:
		if planet.name == data["mission"]:
			planet.add_to_group("destination")
	var destination_planet = get_tree().get_first_node_in_group("destination")
	if destination_planet is RigidBody2D:
		for dictionary in destination_planet.body_shape_entered.get_connections():
			destination_planet.body_shape_entered.disconnect(dictionary["callable"])
		for dictionary in destination_planet.body_shape_exited.get_connections():
			destination_planet.body_shape_exited.disconnect(dictionary["callable"])
		destination_planet.body_shape_entered.connect(on_body_shape_entered)
		destination_planet.body_shape_exited.connect(on_body_shape_exited)
	
	get_tree().paused = false

func exit(_next_state: String):
	self.galaxy_texture.hide()
	var destination_planet = get_tree().get_first_node_in_group("destination")
	destination_planet.remove_from_group("destination")
	owner.remove_child(self.simulation)
	self.simulation.request_ready()
	self.simulation.hide()
	self.game_control.hide()
	self.galaxy_texture.hide()
	self.camera_2d.enabled = false
	await get_tree().process_frame
	self.ui_control.show()
	await self.ui_control.fade_in([self.ui_control], 1)
	
	owner.add_child(self.simulation)

func on_body_shape_entered(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int):
	var collision_shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	var win_timer = self.simulation.get_node("WinTimer") as Timer
	
	if collision_shape.name == "Feet":
		self.feet_count += 1
	
	if self.feet_count == 2 and win_timer.time_left == 0:
		win_timer.start()

func on_body_shape_exited(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int):
	var collision_shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	var win_timer = self.simulation.get_node("WinTimer") as Timer
	
	if collision_shape.name == "Feet":
		self.feet_count -= 1
	
	if self.feet_count < 2:
		win_timer.stop()

func _on_win_timer_timeout() -> void:
	self.finished.emit("home", {})
