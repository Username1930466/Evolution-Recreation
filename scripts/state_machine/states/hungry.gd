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
	if blob != null:
		sight = blob.sight
		var nodes = get_tree().get_nodes_in_group("food")
		iterate_through_group(nodes)
	else:
		print("Blob not assigned to Hungry!")

func physics_update(delta):
	speed = blob.speed
	hunger = blob.hunger
	if target_food == null:
		if search_time > 0:
			blob.velocity = move_direction * speed
			search_time -= delta
		else:
			 # Retry finding target food
			var nodes = get_tree().get_nodes_in_group("food")
			iterate_through_group(nodes)
	else:
		var direction = target_food.global_position - blob.global_position
		
		if direction.length() > 2:
			blob.velocity = direction.normalized() * speed
		else:
			target_food.eat(blob)
			blob.velocity = Vector2()
	if hunger > blob.stomach_capacity / 2:
		transitioned.emit(self, "idle")

func iterate_through_group(nodes):
	speed = blob.speed
	for node in nodes:
		if node.position.distance_to(blob.position) <= sight:
			target_food = node
			break
	
	if target_food == null:
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("food"):
		area.queue_free()
