extends State

@export var ui_control: UIControl

func enter(previous_state: String, _data: Dictionary) -> void:
	if self.ui_control == null:
		push_error("UI Control missing")
		return

	get_tree().paused = true
	
	self.ui_control.show()
	self.ui_control.hide_all(["Title"])
	
	var title = self.ui_control.get_node("Title") as Control
	var name_prompt = self.ui_control.get_node("NamePrompt") as LineEdit
	var start_button = self.ui_control.get_node("StartButton") as Button
	var rocks = self.ui_control.get_node("Rocks") as TextureRect
	
	name_prompt.clear()
	for control in [title, name_prompt, start_button]:
		control.show()

	if !start_button.is_connected("pressed", on_start_button_pressed):
		start_button.pressed.connect(on_start_button_pressed)
	
	self.ui_control.tween_position([rocks], rocks.position, Vector2.ZERO)
	
	if !previous_state.is_empty():
		self.ui_control.fade_in([name_prompt, start_button])
		self.ui_control.tween_scale([title], Vector2.ONE / 2.0, Vector2.ONE)
		self.ui_control.tween_position([title], title.position, Vector2(0, 100))
	else:
		self.ui_control.fade_in([title, name_prompt, start_button])
	

func exit(_next_state: String) -> void:
	var title = self.ui_control.get_node("Title") as Control
	var name_prompt = self.ui_control.get_node("NamePrompt") as LineEdit
	var start_button = self.ui_control.get_node("StartButton") as Button
	var rocks = self.ui_control.get_node("Rocks") as TextureRect
	
	self.ui_control.tween_scale([title], Vector2.ONE, Vector2.ONE / 2.0)
	self.ui_control.tween_position([title], title.position, Vector2(0, -50))
	self.ui_control.tween_position([rocks], rocks.position, Vector2(0, 200))
	await self.ui_control.fade_out([name_prompt, start_button])

	name_prompt.hide()
	start_button.hide()

func physics_update(_delta: float):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	elif Input.is_key_pressed(KEY_ENTER):
		on_start_button_pressed()

func on_start_button_pressed() -> void:
	var name_prompt = self.ui_control.get_node("NamePrompt") as LineEdit
	if name_prompt.text.is_empty():
		return
	self.finished.emit("lobby", {"name": name_prompt.text}) 
