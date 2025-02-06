extends State

@export var mission_container: VBoxContainer
@export var lobby_container: VBoxContainer
@export var back_button: TextureButton


func enter(_previous_state: String) -> void:
	if State.has_null([
		self.lobby_container
	]):
		
		return
	
#	back_button.pressed.connect(on_back_button_pressed)
	
	get_tree().paused = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		self.lobby_container,
		"modulate",
		Color(1, 1, 1, 0),
		0.5
	)
	self.mission_container.show()
	self.mission_container.modulate = Color(1, 1, 1, 0)
	
	tween.chain().tween_property(
		self.mission_container,
		"modulate",
		Color(1, 1, 1, 1),
		0.5
	)
	await tween.finished
	self.lobby_container.hide()
	
func exit() -> void:
	pass

#func on_back_button_pressed():
#	var tween = get_tree().create_tween().set_parallel(true)
#	tween.set_ease(Tween.EASE_IN_OUT)
#	tween.set_trans(Tween.TRANS_SINE)
#	tween.tween_property(
#		self.mission_container,
#		"modulate",
#		Color(1, 1, 1, 0),
#		0.5
#	)
#	print("dkjfhdsfujkkgbhs")
#	self.finished.emit("lobby")
