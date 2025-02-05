extends State

@export var control: Control
@export var start_button: Button
@export var line_edit: LineEdit

func enter(_previous_state: String) -> void:
	if State.has_null([
		self.control,
		self.start_button,
	]):
		return
		
	self.control.show()
	start_button.pressed.connect(on_start_button_pressed)
	get_tree().paused = true

	
func exit() -> void:
	if State.has_null([
		self.control,
	]):
		return
	
	self.control.hide()

func on_start_button_pressed():
	if State.has_null([
		self.line_edit,
	]):
		return
	
	if self.line_edit.text.is_empty():
		return

	self.finished.emit("lobby")
