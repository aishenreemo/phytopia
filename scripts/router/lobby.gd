extends State

@export var ui_control: UIControl

func enter(previous_state: String, data: Dictionary):
	if self.ui_control == null:
		push_error("UI Control missing")
		return

	get_tree().paused = true
	
	self.ui_control.show()
	self.ui_control.hide_all(["Title"])
	
	var astronaut_rocket = self.ui_control.get_node("AstronautRocket") as Control
	var back_buttton = self.ui_control.get_node("BackButton") as TextureButton
	var title = self.ui_control.get_node("Title") as Control
	
	var select_mission_label = self.ui_control.get_node("SelectMissionLabel") as Label
	var planet_selection = self.ui_control.get_node("PlanetSelection") as Control
	
	title.position = Vector2(0, -50)
	title.scale = Vector2.ONE / 2.0
	
	for control in [title, back_buttton, astronaut_rocket, select_mission_label, planet_selection]:
		control.show()
	
	for dictionary in back_buttton.pressed.get_connections():
		back_buttton.pressed.disconnect(dictionary["callable"])
	back_buttton.pressed.connect(func(): self.finished.emit("home", {}))
	
	var planets = planet_selection.get_children() as Array[TextureButton]
	for button in planets:
		for dictionary in button.pressed.get_connections():
			button.pressed.disconnect(dictionary["callable"])
		
		button.pressed.connect(func():
			data["mission"] = String(button.name)
			self.finished.emit("mission", data)
		)
		
	self.ui_control.fade_in([select_mission_label, planet_selection])
	if previous_state == "home":
		self.ui_control.fade_in([back_buttton, astronaut_rocket])
		
func exit(next_state: String):
	var astronaut_rocket = self.ui_control.get_node("AstronautRocket") as Control
	var back_buttton = self.ui_control.get_node("BackButton") as TextureButton
	var select_mission_label = self.ui_control.get_node("SelectMissionLabel") as Label
	var planet_selection = self.ui_control.get_node("PlanetSelection") as Control
	if next_state == "home":
		self.ui_control.fade_out([back_buttton, astronaut_rocket], 0.2)
	await self.ui_control.fade_out([select_mission_label, planet_selection], 0.2)
