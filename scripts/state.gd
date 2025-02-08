extends Node
class_name State

signal finished(next_state_path: String, data: Dictionary)

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func enter(_previous_state: String, _data: Dictionary) -> void:
	pass

func exit(_next_state: String) -> void:
	pass

static func has_null(array: Array):
	return array.any(func(a): return a == null)
