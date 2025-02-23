extends State

@export var ui_control: UIControl
@export var database: Database

func enter(_previous_state: String, data: Dictionary) -> void:
	if self.ui_control == null:
		push_error("UI Control missing")
		return

	get_tree().paused = true
	self.ui_control.show()
	var score = self.ui_control.get_node("Leaderboard/VBoxContainer/Score")
	
	if data.has("name") and data.has("mission") and data.has("duration"):
		var player = self.database.find_player(data["name"], data["mission"])
		score.show()
		score.get_node("NameRect/Name").text = " %s" % [data["name"]]
		score.get_node("DurationRect/Duration").text = " %dm %02ds" % [data["duration"] / 60, data["duration"] % 60]
		
		if player == null:
			self.database.insert_player(data["name"], data["mission"], data["duration"])
		elif player["duration"] > data["duration"]:
			self.database.delete_player(data["name"], data["mission"])
			self.database.insert_player(data["name"], data["mission"], data["duration"])
	else:
		score.hide()
	
	var planet_selection = self.ui_control.get_node("PlanetSelection")
	var back_button = self.ui_control.get_node("BackButton")
	var leaderboard_label = self.ui_control.get_node("LeaderboardLabel")
	var leaderboard = self.ui_control.get_node("Leaderboard")
	
	for control in [planet_selection, back_button, leaderboard, leaderboard_label]:
		control.show()
		
	planet_selection.position.y = 525
	planet_selection.scale = Vector2(0.5, 0.5)
	
	var planets = planet_selection.get_children() as Array[TextureButton]
	for button in planets:
		for dictionary in button.pressed.get_connections():
			button.pressed.disconnect(dictionary["callable"])
		button.pressed.connect(func(): self.make_leaderboard(button.name))

	for dictionary in back_button.pressed.get_connections():
		back_button.pressed.disconnect(dictionary["callable"])
	back_button.pressed.connect(func(): self.finished.emit("home", {}))
	if data.has("mission"):
		self.make_leaderboard(data["mission"])
	await self.ui_control.fade_in([planet_selection, back_button, leaderboard, leaderboard_label])

func make_leaderboard(planet: String):
	var score = self.ui_control.get_node("Leaderboard/VBoxContainer/Score")
	var vbox = self.ui_control.get_node("Leaderboard/VBoxContainer/ScrollContainer/VBoxContainer")
	var players = self.database.find_players_from_planet(planet)
	
	for child in vbox.get_children():
		child.queue_free()
	
	for player in players:
		var copy = score.duplicate() as Control
		var name_rect = copy.get_node("NameRect")
		var duration_rect = copy.get_node("DurationRect")
		copy.set_v_size_flags(Control.SIZE_FILL)
		name_rect.color = Color(1, 1, 1, 1)
		duration_rect.color = Color(1, 1, 1, 1)
		name_rect.get_node("Name").text = " %s" % [player["name"]]
		name_rect.get_node("Name").modulate = Color(0, 0, 0, 1)
		
		duration_rect.get_node("Duration").text = " %dm %02ds" % [player["duration"] / 60, player["duration"] % 60]
		duration_rect.get_node("Duration").modulate = Color(0, 0, 0, 1)
		vbox.add_child(copy)

func exit(_next_state: String) -> void:
	var planet_selection = self.ui_control.get_node("PlanetSelection")
	var leaderboard_label = self.ui_control.get_node("LeaderboardLabel")
	var leaderboard = self.ui_control.get_node("Leaderboard")
	var back_button = self.ui_control.get_node("BackButton")
	
	await self.ui_control.fade_out([planet_selection, back_button, leaderboard, leaderboard_label])
	for control in [back_button, leaderboard, leaderboard_label]:
		control.hide()
