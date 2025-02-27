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
	if blob != null:
		sight = blob.sight
		var nodes = get_tree().get_nodes_in_group("water")
		iterate_through_group(nodes)
	else:
		print("Blob not assigned to Thirsty!")

func physics_update(delta):
	speed = blob.speed
	thirst = blob.thirst
	if target_water == null:
		if search_time > 0:
			blob.velocity = move_direction * speed
			search_time -= delta
		else:
			 # Retry finding target water
			var nodes = get_tree().get_nodes_in_group("water")
			iterate_through_group(nodes)
	else:
		var direction = target_water.global_position - blob.global_position
		
		if direction.length() > 2:
			blob.velocity = direction.normalized() * speed
		else:
			target_water.drink(blob)
			blob.velocity = Vector2()
	if thirst > blob.starting_thirst / 2:
		transitioned.emit(self, "idle")

func iterate_through_group(nodes):
	for node in nodes:
		if node.position.distance_to(blob.position) <= sight:
			target_water = node
			break
	
	if target_water == null:
		speed = blob.speed
		move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		search_time = sight / speed

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("water"):
		pass
