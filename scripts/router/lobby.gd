extends State

@export var main_control: MainControl
@export var camera_2d: Camera2D
@export var rocks: TextureRect

func enter(previous_state: String) -> void:
	self.main_control.show()
	self.main_control.lobby_control.show()
	self.main_control.mission_control.hide()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	
	if previous_state == "home":
		tween.tween_property(
			self.rocks,
			"position:y",
			100,
			2.0
		)
		
	tween.tween_property(
		self.main_control.main_menu_control,
		"modulate",
		Color(1, 1, 1, 0),
		0.5
	)
	
	self.main_control.lobby_control.modulate = Color(1, 1, 1, 0)
	
	tween.chain().tween_property(
		self.main_control.lobby_control,
		"modulate",
		Color(1, 1, 1, 1),
		0.5
	)
	
	await tween.finished
	self.main_control.main_menu_control.hide()
	
func exit() -> void:
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		self.main_control.lobby_control,
		"modulate",
		Color(1, 1, 1, 0),
		0.5
	)
	await tween.finished

func _on_mars_pressed() -> void:
	self.finished.emit("mission")

func _on_jupiter_pressed() -> void:
	self.finished.emit("mission")

func _on_saturn_pressed() -> void:
	self.finished.emit("mission")

func _on_back_button_pressed() -> void:
	self.finished.emit("home")
