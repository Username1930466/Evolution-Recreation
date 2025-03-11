extends state
class_name sleeping

@export var blob: CharacterBody2D
var sprite
var hunger
var thirst

func enter():
	 # Check if blob is assigned
	if blob != null:
		 # Stop moving, change sprite to sleeping
		blob.velocity = Vector2.ZERO
		sprite = blob.get_node("Sprite")
		sprite.texture = load("res://art/SleepingBlob.png")
	else:
		print("Blob not assigned to Sleeping!")

func update(delta):
	hunger = blob.hunger
	thirst = blob.thirst
	
	blob.rest += blob.stat_decrease_rate * 3 * delta
	
	 # If rested enough, enter idle
	if blob.rest >= blob.starting_rest:
		transitioned.emit(self, "idle")
		sprite.texture = load("res://art/Blob.png")
	if blob.hunger + blob.fat * 3 < blob.stomach_capacity / 2 or blob.thirst < blob.starting_thirst / 2: # If blob is also hungry or thristy
		var tlh = (hunger + blob.fat * 3) / blob.stat_decrease_rate # Determine time left until death of starvation
		var tlt = thirst / blob.stat_decrease_rate  # Determine time left until death of dehydration
		var tlr = blob.rest / blob.stat_decrease_rate  # Determine time left until death of sleep deprivation
		if tlh < tlt and tlh < tlr: # If blob will die of starvation fastest, look for food
			transitioned.emit(self, "hungry")
			sprite.texture = load("res://art/Blob.png")
		elif tlt < tlh and tlt < tlr: # if blob will die of dehydration fastest, look for water
			transitioned.emit(self, "thirsty")
			sprite.texture = load("res://art/Blob.png")
		# If blob will die of sleep deprivation first, continue in the sleeping state
