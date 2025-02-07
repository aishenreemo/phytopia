extends State

@export var main_control: MainControl
@export var back_button: TextureButton
@export var start_button: Button

func enter(_previous_state: String) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	
	self.main_control.mission_control.show()
	self.main_control.mission_control.modulate = Color(1, 1, 1, 0)
	
	tween.tween_property(
		self.main_control.mission_control,
		"modulate",
		Color(1, 1, 1, 1),
		0.5
	)
	
	await tween.finished
	self.main_control.lobby_control.hide()
	
func exit() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
		
	tween.tween_property(
		self.main_control.mission_control,
		"modulate",
		Color(1, 1, 1, 0),
		0.5
	)
	
	await tween.finished

func _on_back_button_pressed() -> void:
	self.finished.emit("lobby")

func _on_start_mission_button_pressed() -> void:
	self.finished.emit("game")
