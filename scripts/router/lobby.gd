extends State

@export var main_menu_container: VBoxContainer
@export var lobby_container: VBoxContainer
@export var mission_container: VBoxContainer
@export var camera_2d: Camera2D
@export var rocks: TextureRect

@export var jupiter: TextureButton
@export var mars: TextureButton
@export var saturn: TextureButton

func enter(_previous_state: String) -> void:
	if State.has_null([
		self.rocks,
		self.main_menu_container,
	]):
		
		return
		
	jupiter.pressed.connect(jupiter_select)
	mars.pressed.connect(mars_select)
	saturn.pressed.connect(saturn_select)
	
	get_tree().paused = false
	var tween = get_tree().create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		self.rocks,
		"position:y",
		100,
		2.0
	)
	tween.tween_property(
		self.main_menu_container,
		"modulate",
		Color(1, 1, 1, 0),
		0.5
	)
	
	self.lobby_container.show()
	self.lobby_container.modulate = Color(1, 1, 1, 0)
	
	tween.chain().tween_property(
		self.lobby_container,
		"modulate",
		Color(1, 1, 1, 1),
		0.5
	)
	
	await tween.finished
	self.main_menu_container.hide()
	
func exit() -> void:
	pass

func jupiter_select():
	print("dkjfhdsfujkkgbhs")
	self.finished.emit("mission")
	
func mars_select():
	print("dkjfhdsfujkkgbhs")
	self.finished.emit("mission")
	
func saturn_select():
	print("dkjfhdsfujkkgbhs")
	self.finished.emit("mission")
