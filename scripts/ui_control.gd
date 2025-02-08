extends Control
class_name UIControl

func hide_all(except: Array[String] = []):
	var hide_except = [
		"Background",
		"Stars",
		"Clouds",
		"Rocks",
	]
	hide_except.append_array(except)
	for child in self.get_children():
		if child.name in hide_except:
			continue
		child.hide()

func fade_in(controls: Array[Control], duration: float = 0.5):
	await self.tween_transparency(controls, 0.0, 1.0, duration)

func fade_out(controls: Array[Control], duration: float = 0.5):
	await self.tween_transparency(controls, 1.0, 0.0, duration)

func tween_scale(controls: Array[Control], from: Vector2, to: Vector2, duration: float = 0.5):
	var tween = self.create_default_tween()
	for control in controls:
		control.scale = from
		tween.tween_property(control, "scale", to, duration)
	await tween.finished

func tween_position(controls: Array[Control], from: Vector2, to: Vector2, duration: float = 0.5):
	var tween = self.create_default_tween()
	for control in controls:
		control.position = from
		tween.tween_property(control, "position", to, duration)
	await tween.finished

func tween_transparency(controls: Array[Control], from: float, to: float, duration: float = 0.5):
	var tween = self.create_default_tween()
	for control in controls:
		control.modulate.a = from
		tween.tween_property(control, "modulate:a", to, duration)
	await tween.finished

func create_default_tween() -> Tween:
	var tween = self.create_tween()
	tween.set_parallel(true)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	return tween
