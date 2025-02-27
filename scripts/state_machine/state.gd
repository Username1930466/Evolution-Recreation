extends Node
class_name state

 # Sent whenever a blob transitions from one state to another
signal transitioned

 # Called whenever a blob goes into a state
func enter():
	pass

 # Called whenever a blob leaves a state
func exit():
	pass

 # Equiv of _process function
func update(delta):
	pass

 # Equiv of _physics_process function
func physics_update(delta):
	pass
