extends State

@export var main_control: MainControl
@export var start_button: Button
@export var line_edit: LineEdit

func enter(_previous_state: String) -> void:
	self.line_edit.clear()
	self.main_control.show()
	self.main_control.main_menu_control.show()
	self.main_control.lobby_control.hide()
	self.main_control.mission_control.hide()
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(
		self.main_control.main_menu_control,
		"modulate",
		Color(1, 1, 1, 1),
		0.5
	)
	get_tree().paused = true
	
func exit() -> void:
	pass

func _on_button_pressed() -> void:
	if self.line_edit.text.is_empty():
		return
	self.finished.emit("lobby") 
