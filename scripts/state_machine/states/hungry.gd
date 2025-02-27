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

func iterate_through_group(nodes):
	speed = blob.speed
	 # Look through all the foods
	for node in nodes:
		if node.position.distance_to(blob.position) <= sight:
			 # If food is in sight range, make it target food
			target_food = node
			break
	
	if target_food == null:
		 # If no food in range, pick a random direction and walk for a bit
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed
