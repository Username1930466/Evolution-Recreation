extends Area2D

@export var hunger_value = 30

func _on_body_entered(body) -> void:
	if body.name.find("Blob") != -1:
		var state_machine = body.get_node("StateMachine")
		if body.hunger < body.stomach_capacity / 2:
			body.hunger += hunger_value
			queue_free()

func eat(blob):
	blob.hunger += hunger_value
	queue_free()
