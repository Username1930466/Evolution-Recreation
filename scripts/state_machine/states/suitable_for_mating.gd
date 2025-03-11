extends state
class_name suitable_for_mating

@export var blob: CharacterBody2D
var speed
var sight
var hunger
var thirst
var rest
var gender
var target_mate
var move_direction: Vector2
var search_time: float

func enter():
	 # Check if blob is assigned
	if blob != null:
		sight = blob.sight
		gender = blob.gender
		 # Initial check for mate
		var nodes = get_tree().get_nodes_in_group("suitable_for_mating")
		iterate_through_group(nodes)
		blob.add_to_group("suitable_for_mating")
	else:
		print("Blob not assigned to Suitable For Mating!")

func physics_update(delta):
	speed = blob.speed
	hunger = blob.hunger
	thirst = blob.thirst
	rest = blob.rest
	if target_mate == null:
	 # If no target mate, continue searching
		if search_time > 0:
			blob.velocity = move_direction * speed
			search_time -= delta
		else:
			 # Retry finding target mate after search time is up
			var nodes = get_tree().get_nodes_in_group("suitable_for_mating")
			iterate_through_group(nodes)
	else:
		 # Check if mate is no longer suitable
		if target_mate.is_in_group("suitable_for_mating") == false:
			var nodes = get_tree().get_nodes_in_group("suitable_for_mating")
			iterate_through_group(nodes)
			
			 # If target mate, get direction to mate
		var direction = target_mate.global_position - blob.global_position
		if direction.length() > 15:
			# Go to mate
			blob.velocity = direction.normalized() * speed
		else:
			if target_mate.is_in_group("suitable_for_mating") == true:
				 # If female, give birth
				if gender == "female":
					blob.birth_a_child(target_mate)
				 # If male, mate gives birth
				elif gender == "male":
					target_mate.birth_a_child(blob)
				# If genderless, whoever has higher random number gives birth
				else:
					if blob.rand_num > target_mate.rand_num:
						blob.birth_a_child(target_mate)
					else:
						target_mate.birth_a_child(blob)
				 # Remove from group, give mating cooldown, and go idle
				blob.velocity = Vector2()
				transitioned.emit(self, "idle")
				blob.remove_from_group("suitable_for_mating")
				target_mate.remove_from_group("suitable_for_mating")
				blob.mating_cooldown = 5
				target_mate.mating_cooldown = 5
	 # If no longer suitable, remove from group and idle
	if blob.mating_cooldown > 0 or hunger < blob.stomach_capacity * 0.66667 or thirst < blob.starting_thirst / 2 or rest < blob.starting_rest * 0.41667:
		blob.remove_from_group("suitable_for_mating")
		transitioned.emit(self, "idle")

func iterate_through_group(nodes):
	speed = blob.speed
	 # Look through all the mates
	var possible_target_nodes : Dictionary
	possible_target_nodes.clear()
	for node in nodes:
		 # If within sight and suitable gender, make target_mate
		if gender == "female":
			if node.position.distance_to(blob.position) <= sight and node.gender == "male" and blob.generation == node.generation:
				possible_target_nodes[possible_target_nodes.size()] = node
		if gender == "male":
			if node.position.distance_to(blob.position) <= sight and node.gender == "female" and blob.generation == node.generation:
				possible_target_nodes[possible_target_nodes.size()] = node
		if gender == "genderless":
			if node.position.distance_to(blob.position) <= sight and node.gender == "genderless" and blob.generation == node.generation and node != blob:
				possible_target_nodes[possible_target_nodes.size()] = node
	
	if possible_target_nodes == {}:
		 # If no suitable mates in range, pick a random direction and walk for a bit
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed
	else:
		 # Find closest mate and make it target mate
		var closest_node = blob.main.get_node("AMONGUS") # Start by setting closest to something far offscreen
		for node in possible_target_nodes.values(): # Then run through every one in range and see if its closer
			if node.position.distance_to(blob.position) < closest_node.position.distance_to(blob.position):
				closest_node = node
		target_mate = closest_node
