@tool
extends Node

@export var duration: float = 0.1

var parent : Control
var default_scale: Vector2

func _ready() -> void:
	parent = get_parent()
	default_scale = parent.scale
	parent.mouse_entered.connect(on_hover)
	parent.mouse_exited.connect(off_hover)
	
func on_hover() -> void:
	add_tween("scale", parent.scale * 1.1, duration)

func off_hover() -> void:
	add_tween("scale",  default_scale, duration)
	
func add_tween(property: String, value, seconds: float) -> void:
	var tween = self.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		parent, 
		property, 
		value, 
		seconds
	)
