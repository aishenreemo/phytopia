extends Control
class_name GameControl

@export var gear_slider: HSlider

signal gear_value_changed(value: float)
signal quit

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("gear_up"):
		gear_slider.value += 1
	if Input.is_action_just_pressed("gear_down"):
		gear_slider.value -= 1

func _on_gear_value_changed(value: float) -> void:
	self.gear_value_changed.emit(value)

func _on_button_pressed() -> void:
	self.quit.emit()
