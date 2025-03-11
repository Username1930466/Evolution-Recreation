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
			if blob.position.x < -576 or blob.position.x > 576 or blob.position.y < -324 or blob.position.y > 324:
				var nodes = get_tree().get_nodes_in_group("water")
				iterate_through_group(nodes) # Stop moving and pick a new direction for when the blob leaves the edge
			else:
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
	if blob.hunger + blob.fat * 3 < blob.stomach_capacity / 2 or blob.rest <= blob.starting_rest / 3: # If blob is also hungry or tired
		var tlh = (blob.hunger + blob.fat * 3) / blob.stat_decrease_rate # Determine time left until death of starvation
		var tlt = thirst / blob.stat_decrease_rate  # Determine time left until death of dehydration
		var tlr = blob.rest / blob.stat_decrease_rate  # Determine time left until death of sleep deprivation
		if tlh < tlt and tlh < tlr:  # If blob will die of starvation fastest, look for food
			transitioned.emit(self, "hungry")
		elif tlr < tlh and tlr < tlt:
			transitioned.emit(self, "sleeping") # if blob will die of sleep deprivation fastest, go to sleep
		# If blob will die of dehydration first, continue in the thirsty state

func iterate_through_group(nodes):
	var possible_target_nodes : Dictionary
	possible_target_nodes.clear()
	for node in nodes:
		 # Look through all the waters
		if node.position.distance_to(blob.position) <= sight:
			 # If water is in sight range, make it target water
			possible_target_nodes[possible_target_nodes.size()] = node
	
	if possible_target_nodes == {}:
		 # If no water in range, pick a random direction and walk for a bit
		speed = blob.speed
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed
	else:
		 # Find closest water and make it target water
		var closest_node = blob.main.get_node("AMONGUS") # Start by setting closest to something far offscreen
		for node in possible_target_nodes.values(): # Then run through every one in range and see if its closer
			if node.position.distance_to(blob.position) < closest_node.position.distance_to(blob.position):
				closest_node = node
		target_water = closest_node
