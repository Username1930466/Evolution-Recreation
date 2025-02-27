extends Area2D

@export var hunger_value = 30

func _on_body_entered(body) -> void:
	 # If touching anything, continue
	if body.name.find("Blob") != -1:
		 # If thing touched is blob, continue
		if body.hunger < body.stomach_capacity / 2:
			 # If the blob is hungry, give blob hunger and delete
			body.hunger += hunger_value
			queue_free()

func eat(blob):
	 # If blob became hungry after it entered plants collision box, get eaten
	blob.hunger += hunger_value
	queue_free()
