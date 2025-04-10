extends Camera2D

@export_range(1, 1024) var multiplier = 8:
	set(new_multiplier):
		multiplier = new_multiplier
		self.limit_left = -16 * 40 * self.multiplier
		self.limit_top = -9 * 40 * self.multiplier
		self.limit_right = 16 * 40 * self.multiplier
		self.limit_bottom = 9 * 40 * self.multiplier

@export var follow: Node2D

var is_focusing = true
var is_dragging = false
var maximum_zoom: Vector2
var minimum_zoom: Vector2
var current_tween: Tween = null

func _ready() -> void:
	var screen_size = get_viewport().size as Vector2
	self.limit_left = -screen_size.x / 2 * self.multiplier
	self.limit_top = -screen_size.y / 2 * self.multiplier
	self.limit_right = screen_size.x / 2 * self.multiplier
	self.limit_bottom = screen_size.y / 2 * self.multiplier
	
	var limit_rect = Vector2(
		self.limit_right - self.limit_left,
		self.limit_bottom - self.limit_top
	)
	
	self.maximum_zoom = limit_rect / screen_size
	self.minimum_zoom = screen_size / limit_rect

func _physics_process(_delta: float) -> void:
	var screen_size = get_viewport().size
	var minimum_position = Vector2(
		0.5 * screen_size.x * (1.0 / self.zoom.x) + self.limit_left,
		0.5 * screen_size.y * (1.0 / self.zoom.y) + self.limit_top,
	)
	var maximum_position = Vector2(
		-0.5 * screen_size.x * (1.0 / self.zoom.x) + self.limit_right,
		-0.5 * screen_size.y * (1.0 / self.zoom.y) + self.limit_bottom,
	)
	if self.follow is RigidBody2D:
		self.offset = self.follow.linear_velocity * 0.2
	
	if Input.is_action_just_pressed("lock"):
		self.is_focusing = !self.is_focusing
	elif Input.is_action_just_pressed("zoom_1x"):
		self.zoom = Vector2.ONE
		self.is_focusing = true
	elif Input.is_action_just_pressed("zoom_2x"):
		self.zoom = Vector2.ONE / 4.0
		self.is_focusing = true
	elif Input.is_action_just_pressed("zoom_3x"):
		self.zoom = Vector2.ONE / 16.0
		self.is_focusing = true
	elif Input.is_action_just_pressed("zoom_all"):
		self.zoom = Vector2.ONE / self.multiplier
		self.is_focusing = false
		if self.current_tween:
			self.current_tween.kill()
			self.current_tween = null
	elif Input.is_action_pressed("align") and self.follow is RigidBody2D:
		self.rotation = -self.follow.linear_velocity.angle_to(Vector2.DOWN)
		self.position = self.follow.position
		
	if self.follow and self.is_focusing or Input.is_action_pressed("focus"):
		self.position = self.follow.position
		
		if Input.is_action_pressed("focus"):
			self.rotation = self.follow.rotation
		
	self.position.x = clamp(self.position.x, minimum_position.x, maximum_position.x)
	self.position.y = clamp(self.position.y, minimum_position.y, maximum_position.y)
	
func _input(event: InputEvent) -> void:
	if !self.enabled:
		return
		
	var is_zoomed = false

	if event is InputEventMouseMotion and is_dragging:
		self.position -= event.relative.rotated(self.rotation) / self.zoom
		is_zoomed = true
		
	var delta_zoom = 1.05
	var old_position = get_global_mouse_position()

	if event is InputEventMouseButton:
		if event.shift_pressed:
			delta_zoom = 1.1
		
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			self.is_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			self.zoom *= delta_zoom
			is_zoomed = true
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			self.zoom /= delta_zoom
			is_zoomed = true
	
	if !is_zoomed:
		return
	
	var new_position = get_global_mouse_position()
	if self.zoom * 1.00001 < self.maximum_zoom:
		self.global_position += old_position - new_position
	
	self.zoom = clamp(self.zoom, self.minimum_zoom, self.maximum_zoom)
	for line in get_tree().get_nodes_in_group("trajectory"):
		line.width = 1.0 / self.zoom.x
