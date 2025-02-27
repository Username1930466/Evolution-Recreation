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
	if blob != null:
		sight = blob.sight
		gender = blob.gender
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
		if search_time > 0:
			blob.velocity = move_direction * speed
			search_time -= delta
		else:
			 # Retry finding target mate
			var nodes = get_tree().get_nodes_in_group("suitable_for_mating")
			iterate_through_group(nodes)
	else:
		if target_mate.is_in_group("suitable_for_mating") == false:
			var nodes = get_tree().get_nodes_in_group("suitable_for_mating")
			iterate_through_group(nodes)
			
		var direction = target_mate.global_position - blob.global_position
		if direction.length() > 15:
			blob.velocity = direction.normalized() * speed
		else:
			if target_mate.is_in_group("suitable_for_mating") == true:
				if gender == "female":
					blob.birth_a_child(target_mate)
				elif gender == "male":
					target_mate.birth_a_child(blob)
				else:
					if blob.rand_num > target_mate.rand_num:
						blob.birth_a_child(target_mate)
					else:
						target_mate.birth_a_child(blob)
				blob.velocity = Vector2()
				transitioned.emit(self, "idle")
				blob.remove_from_group("suitable_for_mating")
				target_mate.remove_from_group("suitable_for_mating")
				blob.mating_cooldown = 5
				target_mate.mating_cooldown = 5
	if blob.mating_cooldown > 0 or hunger < blob.stomach_capacity * 0.66667 or thirst < blob.starting_thirst / 2 or rest < blob.starting_rest * 0.41667:
		blob.remove_from_group("suitable_for_mating")
		transitioned.emit(self, "idle")

func iterate_through_group(nodes):
	speed = blob.speed
	for node in nodes:
		if gender == "female":
			if node.position.distance_to(blob.position) <= sight and node.gender == "male":
				target_mate = node
				break
		if gender == "male":
			if node.position.distance_to(blob.position) <= sight and node.gender == "female":
				target_mate = node
				break
		if gender == "genderless":
			if node.position.distance_to(blob.position) <= sight and node.gender == "genderless":
				target_mate = node
				break
	
	if target_mate == null:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed
