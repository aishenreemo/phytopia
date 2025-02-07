@tool
extends Node
@export var duration: float = 0.1

var parent : Control
var default_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	default_size = parent.size

func add_tween(property: String, value, seconds: float) -> void:
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(
		parent, 
		property, 
		value, 
		seconds
	)
