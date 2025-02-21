extends State

@export var ui_control: UIControl

func enter(previous_state: String, data: Dictionary):
	if previous_state != "lobby":
		return
		
	if self.ui_control == null:
		push_error("UI Control missing")
		return

	get_tree().paused = true
	
	self.ui_control.show()
	self.ui_control.hide_all(["Title", "BackButton", "AstronautRocket"])
	
	var back_button = self.ui_control.get_node("BackButton") as TextureButton
	var earth = self.ui_control.get_node("Earth") as TextureRect
	var dialogue_panel = self.ui_control.get_node("DialoguePanel") as Panel
	var start_mission_button = self.ui_control.get_node("StartMissionButton") as Button
	
	for dictionary in back_button.pressed.get_connections():
		back_button.pressed.disconnect(dictionary["callable"])
	
	back_button.pressed.connect(func():
		data.erase("mission")
		self.finished.emit("lobby", data)
	)
	
	for dictionary in start_mission_button.pressed.get_connections():
		start_mission_button.pressed.disconnect(dictionary["callable"])
	
	start_mission_button.pressed.connect(func(): self.finished.emit("game", data))
	
	for control in [earth, dialogue_panel, start_mission_button]:
		control.show()
	self.ui_control.fade_in([earth, dialogue_panel, start_mission_button])

func exit(next_state: String):
	var earth = self.ui_control.get_node("Earth") as TextureRect
	var dialogue_panel = self.ui_control.get_node("DialoguePanel") as Panel
	var start_mission_button = self.ui_control.get_node("StartMissionButton") as Button
	if next_state != "home":
		self.ui_control.fade_out([earth, dialogue_panel, start_mission_button])
	var back_buttton = self.ui_control.get_node("BackButton") as TextureButton
	var astronaut_rocket = self.ui_control.get_node("AstronautRocket") as Control

	if next_state == "game":
		self.ui_control.fade_out([back_buttton, astronaut_rocket])
