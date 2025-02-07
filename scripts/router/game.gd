extends State
@export var main_control: MainControl
@export var user_interface: CanvasLayer
@export var game: Node2D

func enter(previous_state: String) -> void:
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	
	self.game.modulate = Color(1, 1, 1, 0)
	
	tween.tween_property(
		self.main_control,
		"modulate",
		Color(1, 1, 1, 0),
		0.5
	)
	
	self.game.show()
	
	tween.chain().tween_property(
		self.game,
		"modulate",
		Color(1, 1, 1, 1),
		0.5
	)
	
	get_tree().paused = true
	await tween.finished
	
	self.main_control.hide()
	self.user_interface.hide()

func exit() -> void:
	pass
