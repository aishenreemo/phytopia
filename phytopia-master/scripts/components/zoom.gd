extends Node2D

@export var sprite: Node2D
@export var threshold: float = 1.0 / 32.0
@export var multiplier: float = 1.0 / 64.0

var current_tween: Tween

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(_delta: float) -> void:
	if self.sprite == null:
		return
	
	if self.current_tween:
		self.current_tween.kill()
		self.current_tween = null
		
	self.current_tween = self.create_tween()
	self.current_tween.set_ease(Tween.EASE_IN_OUT)
	self.current_tween.set_trans(Tween.TRANS_SINE)
	self.current_tween.set_parallel(true)
	
	var camera = get_tree().get_first_node_in_group("camera")
	var alpha = float(camera.zoom.x < self.threshold)
	var sprite_scale = self.multiplier * Vector2.ONE / camera.zoom.x
	
	self.current_tween.tween_property(self.sprite, "modulate:a", alpha, 0.1)
	self.current_tween.tween_property(self.sprite, "scale", sprite_scale, 0.1)
