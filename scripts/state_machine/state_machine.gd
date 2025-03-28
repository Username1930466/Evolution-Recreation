extends Node

@export var initial_state : state

var current_state : state
var states : Dictionary = {}

func _ready() -> void:
	 # Add children states to the dictionary
	for child in get_children():
		if child is state:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	 # Call the update function every frame
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	 # Call the physics_update function every frame
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name):
	 # Go from one state to the next
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
