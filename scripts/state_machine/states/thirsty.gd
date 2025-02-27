extends state
class_name thirsty

@export var blob: CharacterBody2D
var speed
var sight
var thirst
var target_water
var move_direction: Vector2
var search_time: float

func enter():
	 # Check if blob is assigned
	if blob != null:
		sight = blob.sight
		 # Initial check for water
		var nodes = get_tree().get_nodes_in_group("water")
		iterate_through_group(nodes)
	else:
		print("Blob not assigned to Thirsty!")

func physics_update(delta):
	speed = blob.speed
	thirst = blob.thirst
	if target_water == null:
		 # If no target water, continue searching
		if search_time > 0:
			blob.velocity = move_direction * speed
			search_time -= delta
		else:
			 # Retry finding target water after search time is up
			var nodes = get_tree().get_nodes_in_group("water")
			iterate_through_group(nodes)
	else:
		 # If target water, get direction to water
		var direction = target_water.global_position - blob.global_position
		
		if direction.length() > 2:
			 # Go to water
			blob.velocity = direction.normalized() * speed
		else:
			 # If directly on water and for any reason not drank it, force drink it
			target_water.drink(blob)
			blob.velocity = Vector2()
	 # If no longer thirsty, go back to idle
	if thirst > blob.starting_thirst / 2:
		transitioned.emit(self, "idle")

func iterate_through_group(nodes):
	for node in nodes:
		 # Look through all the waters
		if node.position.distance_to(blob.position) <= sight:
			 # If water is in sight range, make it target water
			target_water = node
			break
	
	if target_water == null:
		 # If no water in range, pick a random direction and walk for a bit
		speed = blob.speed
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed
