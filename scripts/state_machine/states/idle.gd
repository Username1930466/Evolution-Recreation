extends state
class_name idle

@export var blob : CharacterBody2D
var speed
var mating_cooldown
var move_direction : Vector2
var wander_time : float

func randomize_wander():
	 # Pick a random direction to walk in
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	 # Check if blob is assigned
	if blob != null:
		randomize_wander()
	else:
		print("Blob not assigned to Idle!")

func update(delta):
	mating_cooldown = blob.mating_cooldown
	if wander_time > 0:
		wander_time -= delta
	else:
		 # If wonder time ended, pick new direction to wander
		randomize_wander()
	
	 # Check if should be entering any other state
	if blob.hunger < blob.stomach_capacity / 2:
		transitioned.emit(self, "hungry")
	elif blob.thirst < blob.starting_thirst / 2:
		transitioned.emit(self, "thirsty")
	elif blob.rest <= blob.starting_rest / 3:
		transitioned.emit(self, "sleeping")
	elif blob.hunger >= blob.stomach_capacity * 0.66667 and blob.thirst >= blob.starting_thirst * 0.66667 and blob.rest >= blob.starting_rest * 0.41667 and mating_cooldown <= 0:
		transitioned.emit(self, "suitable_for_mating")
	

func physics_update(delta):
	speed = blob.speed
	if blob:
		 # Change velocity for movement (this is sent to the move and slide function in the main script)
		blob.velocity = move_direction * speed
