extends Node
class_name StateMachine

@export var initial_state: State
@export var default_data: Dictionary
var states: Dictionary = {}
var current: State = null

func _ready():
	for child in get_children():
		if child is State:
			var state_name = child.name.to_snake_case()
			self.states[state_name] = child
			self.states[state_name].finished.connect(on_finished)
	
	if self.initial_state:
		self.current = self.initial_state
		self.current.enter("", default_data)

func _process(delta: float):
	if self.current:
		self.current.update(delta)

func _physics_process(delta: float):
	if self.current:
		self.current.physics_update(delta)

func on_finished(next_state_name: String, data: Dictionary):
	var current_name = self.current.name.to_snake_case()
	var next_state_name_snek = next_state_name.to_snake_case()
	
	if next_state_name_snek == current_name:
		push_warning("Entering same state:", next_state_name)
		return
	
	var next_state = self.states.get(next_state_name_snek)
	if !next_state:
		push_error("Invalid state:", next_state_name)
		return
	
	if self.current:
		await self.current.exit(next_state_name_snek)
		next_state.enter(current_name, data)
	else:
		next_state.enter("")
	
	self.current = next_state
