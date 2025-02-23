@tool
extends Node

@export var wave_amplitude: float = 10.0
@export var wave_speed: float = 0.1

var time_elapsed: float = 0.0

func _process(delta):
	var parent = self.get_parent()
	
	if parent is Node:
		time_elapsed = fmod(time_elapsed + delta, 1.0 / wave_speed)
		parent.rotation_degrees = wave_amplitude * sin(wave_speed * 2 * PI * time_elapsed)
