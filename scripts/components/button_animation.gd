@tool
extends Node

@export var from_center: bool = true
@export var hover_scale: Vector2 = Vector2(0.5, 0.5)
@export var click_scale: Vector2 = Vector2(0.1, 0.1)
@export var time: float = 0.1

var parent : Control
var default_scale: Vector2

func _ready() -> void:
	parent = get_parent()
	connect_signals()
	call_deferred("setup")

func connect_signals() -> void:
	parent.mouse_entered.connect(on_hover)
	parent.mouse_exited.connect(off_hover)
	parent.pressed.connect(on_click)
	
func setup() -> void:
	if from_center:
		parent.pivot_offset = parent.size / 2
	default_scale = parent.scale
	
func on_hover() -> void:
	add_tween("scale", hover_scale, time)

func off_hover() -> void:
	add_tween("scale", default_scale, time)

func on_click() -> void:
	add_tween("scale", click_scale, time)

func on_release() -> void:
	add_tween("scale", default_scale, time)

	
func add_tween(property: String, value, seconds: float,) -> void:
	get_tree().paused = false
	var tween = get_tree().create_tween()
	tween.tween_property(
		parent, 
		property, 
		value, 
		seconds)
