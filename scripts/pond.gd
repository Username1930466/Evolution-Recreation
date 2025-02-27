extends Area2D

@export var thirst_value = 30

func _on_body_entered(body) -> void:
	 # If touching anything, continue
	if body.name.find("Blob") != -1:
		 # If thing touched is blob, continue
		if body.thirst < body.starting_thirst / 2:
			 # If the blob is thirsrt, give blob water
			body.thirst += thirst_value

func drink(blob):
	 # If blob became thirsty after it entered ponds collision box, give it water
	blob.thirst += thirst_value
