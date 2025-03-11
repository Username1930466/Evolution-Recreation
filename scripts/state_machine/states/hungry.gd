extends state
class_name hungry

@export var blob: CharacterBody2D
var speed
var sight
var hunger
var target_food
var move_direction: Vector2
var search_time: float

func enter():
	 # Check if blob is assigned
	if blob != null:
		sight = blob.sight
		 # Initial check for food
		var nodes = get_tree().get_nodes_in_group("food")
		iterate_through_group(nodes)
	else:
		print("Blob not assigned to Hungry!")

func physics_update(delta):
	speed = blob.speed
	hunger = blob.hunger
	if target_food == null:
		 # If no target food, continue searching
		if search_time > 0:
			if blob.position.x < -576 or blob.position.x > 576 or blob.position.y < -324 or blob.position.y > 324:
				var nodes = get_tree().get_nodes_in_group("food")
				iterate_through_group(nodes) # Stop moving and pick a new direction for when the blob leaves the edge
			else:
				blob.velocity = move_direction * speed
				search_time -= delta
		else:
			 # Retry finding target food after search time is up
			var nodes = get_tree().get_nodes_in_group("food")
			iterate_through_group(nodes)
	else:
		 # If target food, get direction to food
		var direction = target_food.global_position - blob.global_position
		
		if direction.length() > 2:
			 # Go to food
			blob.velocity = direction.normalized() * speed
		else:
			 # If directly on food and for any reason not eaten it, force eat it
			target_food.eat(blob)
			blob.velocity = Vector2()
	 # If no longer hungry, go back to idle
	if hunger > blob.stomach_capacity / 2:
		transitioned.emit(self, "idle")
	if blob.thirst < blob.starting_thirst / 2 or blob.rest <= blob.starting_rest / 3: # If blob is also thristy or tired
		var tlh = (hunger + blob.fat * 3) / blob.stat_decrease_rate # Determine time left until death of starvation
		var tlt = blob.thirst / blob.stat_decrease_rate  # Determine time left until death of dehydration
		var tlr = blob.rest / blob.stat_decrease_rate  # Determine time left until death of sleep deprivation
		if tlt < tlh and tlt < tlr:  # If blob will die of thirst fastest, look for water
			transitioned.emit(self, "thirsty")
		elif tlr < tlh and tlr < tlt:
			transitioned.emit(self, "sleeping") # if blob will die of sleep deprivation fastest, go to sleep
		# If blob will die of hunger first, continue in the hungry state

func iterate_through_group(nodes):
	speed = blob.speed
	 # Look through all the foods
	var possible_target_nodes : Dictionary
	possible_target_nodes.clear()
	for node in nodes:
		if node.position.distance_to(blob.position) <= sight:
			 # If food is in sight range, make it target food
			possible_target_nodes[possible_target_nodes.size()] = node
	
	if possible_target_nodes == {}:
		 # If no food in range, pick a random direction and walk for a bit
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed
	else:
		 # Find closest food and make it target food
		var closest_node = blob.main.get_node("AMONGUS") # Start by setting closest to something far offscreen
		for node in possible_target_nodes.values(): # Then run through every one in range and see if its closer
			if node.position.distance_to(blob.position) < closest_node.position.distance_to(blob.position):
				closest_node = node
		target_food = closest_node
