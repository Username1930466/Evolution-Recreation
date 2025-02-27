extends Area2D

@export var thirst_value = 30

func _on_body_entered(body) -> void:
	if body.name.find("Blob") != -1:
		var state_machine = body.get_node("StateMachine")
		if body.thirst < body.starting_thirst / 2:
			body.thirst += thirst_value

func drink(blob):
	blob.thirst += thirst_value
