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
	
	 # If hungry or thirty, enter respective state, if rested enough, enter idle
	if hunger < blob.stomach_capacity / 2:
		transitioned.emit(self, "hungry")
		sprite.texture = load("res://art/Blob.png")
	if thirst < blob.starting_thirst / 2:
		transitioned.emit(self, "thirsty")
		sprite.texture = load("res://art/Blob.png")
	if blob.rest >= blob.starting_rest:
		transitioned.emit(self, "idle")
		sprite.texture = load("res://art/Blob.png")
