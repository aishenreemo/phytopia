extends State

@export var main_control: Control
@export var main_menu_container: VBoxContainer
@export var lobby_container: VBoxContainer
@export var start_button: Button
@export var line_edit: LineEdit

func enter(_previous_state: String) -> void:
	if State.has_null([
		self.start_button,
	]):
		return
		
	self.main_control.show()
	self.main_menu_container.show()
	start_button.pressed.connect(on_start_button_pressed)
	get_tree().paused = true

	
func exit() -> void:
	pass
	
func on_start_button_pressed():
	if State.has_null([
		self.line_edit,
	]):
		return

	if self.line_edit.text.is_empty():
		return
	self.finished.emit("lobby")
