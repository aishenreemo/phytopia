extends State

@export var galaxy_texture: TextureRect
@export var ui_control: UIControl
@export var game_control: GameControl
@export var simulation: Simulation
@export var camera_2d: Camera2D

var feet_count: int = 0
var player_name: String
var planet_name: String
var time_elapsed: float = 0.0

func enter(_previous_state: String, data: Dictionary):
	if self.ui_control == null:
		push_error("UI Control missing")
		return
	
	self.player_name = data["name"]
	self.planet_name = data["mission"]
	self.time_elapsed = 0.0
	
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
	var label = self.game_control.get_node("MarginContainer/VBoxContainer/HBoxContainer/Label")
	label.text = "MISSION: GO TO %s" % [data["mission"].to_upper()]
	
	get_tree().paused = false

func physics_update(delta: float):
	self.time_elapsed += delta
	var time_label = self.game_control.get_node("MarginContainer/VBoxContainer/HBoxContainer/Time")
	time_label.text =  " %dm %02ds" % [int(self.time_elapsed / 60), int(self.time_elapsed) % 60]
	var win_timer = self.simulation.get_node("WinTimer") as Timer
	var label = self.game_control.get_node("Label")
	var hp = self.game_control.get_node("MarginContainer/VBoxContainer/HBoxContainer/ProgressBar")
	
	if hp.value <= 0:
		hp.value = 100.0
		self.time_elapsed = 0
		self.finished.emit("home", {})
	if win_timer.time_left > 0:
		label.text = str(int(round(win_timer.time_left)))
		label.show()
	
	var vehicle = owner.get_node_or_null("Game/Vehicle")
	if vehicle != null:
		if vehicle.position.x < self.camera_2d.limit_left or vehicle.position.x > self.camera_2d.limit_right or vehicle.position.y < self.camera_2d.limit_top or vehicle.position.y > self.camera_2d.limit_bottom:
			hp.value = 100.0
			self.time_elapsed = 0
			self.finished.emit("home", {})
	
func exit(_next_state: String):
	self.galaxy_texture.hide()
	var destination_planet = get_tree().get_first_node_in_group("destination")
	if destination_planet != null:
		destination_planet.remove_from_group("destination")
	owner.call_deferred("remove_child", self.simulation)
	self.simulation.request_ready()
	self.simulation.hide()
	self.game_control.hide()
	self.galaxy_texture.hide()
	self.camera_2d.enabled = false
	await get_tree().process_frame
	self.ui_control.show()
	self.ui_control.hide_all()
	await self.ui_control.fade_in([self.ui_control], 1)
	
	owner.add_child(self.simulation)

func on_body_shape_entered(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int):
	var collision_shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	var win_timer = self.simulation.get_node("WinTimer") as Timer
	if collision_shape.name == "Feet":
		self.feet_count += 1

	if self.feet_count == 2 and win_timer.time_left == 0:
		win_timer.start()
		var label = self.game_control.get_node("Label")
		label.show()
		label.text = str(int(round(win_timer.time_left)))
		await self.ui_control.fade_in([label], 0.1)

func on_body_shape_exited(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int):
	var collision_shape = body.shape_owner_get_owner(body.shape_find_owner(body_shape_index))
	var win_timer = self.simulation.get_node("WinTimer") as Timer
	
	if collision_shape.name == "Feet":
		self.feet_count -= 1
	
	if self.feet_count < 2:
		win_timer.stop()
		var label = self.game_control.get_node("Label")
		label.text = ""
		await self.ui_control.fade_out([label], 0.1)
		label.hide()

func _on_win_timer_timeout() -> void:
	self.finished.emit("leaderboard", {
		"name": self.player_name,
		"mission": self.planet_name,
		"duration": int(self.time_elapsed),
	})

func _on_game_control_quit() -> void:
	self.finished.emit("home", {})

func _on_vehicle_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, local_shape_index: int) -> void:
	var vehicle = owner.get_node("Game/Vehicle")
	var collision_shape = vehicle.shape_owner_get_owner(vehicle.shape_find_owner(local_shape_index))
	if collision_shape.name == "Head" and self.time_elapsed > 5.0:
		var hp = self.game_control.get_node("MarginContainer/VBoxContainer/HBoxContainer/ProgressBar")
		hp.value -= 30
