extends CharacterBody2D
class_name blob

 # Set Starting Stats
var hunger : float
var thirst : float
var rest : float
var base_speed : float
var sight : float
var variation_multiplier : float
var stat_decrease_rate : float
var stomach_capacity
var starting_thirst
var starting_rest
var speed
var fat : float
var gender = randi_range(1, 3)
var mating_cooldown = 15
var blob_scene = preload("res://scenes/blob.tscn")
var main
var rand_num
var canvas_layer
var generation
var selected : bool = false

func _ready() -> void:
	stat_decrease_rate = base_speed / 40
	main = get_parent()
	canvas_layer = main.get_node("CanvasLayer")
	main.current_blobs += 1
	add_to_group("blobs")
	
	 # Randomize stats a bit
	hunger = hunger * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	stomach_capacity = hunger
	thirst = thirst * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	starting_thirst = thirst
	base_speed = base_speed * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	speed = base_speed
	sight = sight * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	rest = rest * randf_range(1 - variation_multiplier, 1 + variation_multiplier)
	starting_rest = rest
	$Button.modulate.a = 0
	
	if gender == 1:
		gender = "female"
	elif gender == 2:
		gender = "male"
	else:
		gender = "genderless"
		rand_num = randf_range(0, 100)
	
	 # Hide small stat box
	$MeshInstance2D.visible = false
	$Label.visible = false

func _process(delta: float) -> void:
	 # Decrease stats by 1 per second on average speed
	hunger -= stat_decrease_rate * delta
	thirst -= stat_decrease_rate * delta
	rest -= stat_decrease_rate * delta
	if mating_cooldown > 0:
		mating_cooldown -= 1 * delta
	
	 # If rest is less than 33%, and hungry or thirsty, decrease speed by amount of tiredness
	if rest < starting_rest / 3 and (hunger < stomach_capacity / 2 or thirst < starting_thirst / 2):
		speed = base_speed - ((starting_rest / 3) - rest)
		if speed < 0:
			speed = 0
	else:
		speed = base_speed
	
	 # Add fat if over-ate
	if hunger > stomach_capacity:
		fat += hunger - stomach_capacity
		hunger = stomach_capacity
	
	 # Apply change in speed and size from fat
	var prev_speed = speed
	var size_mult = fat * 0.05 + 1
	scale = Vector2(size_mult, size_mult)
	speed = prev_speed - fat
	
	 # Detect if mouse in hovering over blob
	var mouse_pos = get_global_mouse_position()
	var distance_to_mouse = (position - mouse_pos).length()
	if distance_to_mouse < 10 * size_mult:
		if selected == false:
			 # If it is, show small stat box
			$Label.text = "Hung: " + String("%0.1f" % hunger) + "\nThir: " + String("%0.1f" % thirst) + "\nRest: " + String("%0.1f" % rest) + "\nFat: " + String("%0.1f" % fat)
			$MeshInstance2D.visible = true
			$Label.visible = true
	else:
		 # If not, hide it
		$MeshInstance2D.visible = false
		$Label.visible = false
	
	 # If showing extended stats, update them
	var extended_stats = canvas_layer.get_node("Extended Stats")
	if extended_stats and selected == true:
		update_extended_stats(extended_stats)
	
	if hunger <= 0:
		 # If no fat, die, if yes fat, decrease it
		if fat > 0:
			fat -= stat_decrease_rate * 0.33333 * delta
		else:
			var starved_texture = load("res://art/StarvedBlob.png")
			
			var stamp_sprite = Sprite2D.new()
			stamp_sprite.texture = starved_texture
			stamp_sprite.position = position
			stamp_sprite.modulate = $Sprite.modulate
			stamp_sprite.rotation = randf_range(0, PI * 2)
			stamp_sprite.scale = scale * 0.65
			
			get_parent().add_child(stamp_sprite)
			death()
	
	if thirst <= 0:
		 # Die of dehyration
		var dehydrated_texture = load("res://art/DehydratedBlob.png")
		
		var stamp_sprite = Sprite2D.new()
		stamp_sprite.texture = dehydrated_texture
		stamp_sprite.position = position
		stamp_sprite.rotation = randf_range(0, PI * 2)
		stamp_sprite.scale = scale * 0.65
		
		get_parent().add_child(stamp_sprite)
		death()
	
	if rest <= 0:
		var sleep_deprived_texture = load("res://art/SleepDeprivedBlob.png")
		
		var stamp_sprite = Sprite2D.new()
		stamp_sprite.texture = sleep_deprived_texture
		stamp_sprite.position = position
		stamp_sprite.modulate = $Sprite.modulate
		stamp_sprite.scale = scale * 0.65
		
		get_parent().add_child(stamp_sprite)
		death()

func _physics_process(delta: float) -> void:
	 # Move
	move_and_slide()
	
	 # Bounce off edge of screen if touching it
	if position.x < -576 or position.x > 576:
		velocity.x = -velocity.x
	if position.y < -324 or position.y > 324:
		velocity.y = -velocity.y

func birth_a_child(other_parent):
	 # Create a new blob scene
	main.global_blob_count += 1
	var child = blob_scene.instantiate()
	child.position = position
	var sprite = child.get_node("Sprite")
	 # Average color between parents
	var avg_color = ($Sprite.modulate + other_parent.get_node("Sprite").modulate) / 2
	 # Avergae color between parent 1 and average
	var avg_color_1 = ($Sprite.modulate + avg_color) / 2
	 # Average color between parent 2 and average
	var avg_color_2 = (other_parent.get_node("Sprite").modulate + avg_color) / 2
	 # Set color to random between semi-averages of each parent
	var color = Color(randf_range(avg_color_1.r, avg_color_2.r), randf_range(avg_color_1.g, avg_color_2.g), randf_range(avg_color_1.b, avg_color_2.b), 1)
	sprite.modulate = color
	 # Other stats get a randomness multiplier in the _onready(), so we just take the average
	child.hunger = (stomach_capacity + other_parent.stomach_capacity) / 2
	child.thirst = (starting_thirst + other_parent.starting_thirst) / 2
	child.rest = (starting_rest + other_parent.starting_rest) / 2
	child.base_speed = (base_speed + other_parent.base_speed) / 2
	child.sight = (sight + other_parent.sight) / 2
	child.mating_cooldown = 15
	child.fat = main.starting_fat
	if gender == "female" or "male":
		child.gender = randi_range(1, 2)
	else:
		child.gender = 3
	
	child.set_name("Blob_%d" % main.global_blob_count)
	child.generation = generation + 1
	main.add_child(child)

func update_extended_stats(label):
	 # Update extended stats
	label.text = "Extended Stats:"
	label.text += "\n\nID: " + name
	label.text += "\nState: " + str(get_node("StateMachine").current_state.name)
	label.text += "\n\nHunger: " + String("%0.3f" % hunger)
	label.text += "\nThirst: " + String("%0.3f" % thirst)
	label.text += "\nRest: " + String("%0.3f" % rest)
	label.text += "\nFat: " + String("%0.3f" % fat)
	label.text += "\n\nGender: " + gender
	label.text += "\nBase Speed: " + String("%0.3f" % base_speed)
	label.text += "\nSpeed: " + String("%0.3f" % speed)
	label.text += "\nSight: " + String("%0.3f" % sight)
	label.text += "\nStomach Capacity: " + String("%0.3f" % stomach_capacity)
	label.text += "\nMating Cooldown: " + String("%0.3f" % mating_cooldown)
	label.text += "\nGeneration: " + str(generation)

func death():
	 # Remove from groups, delete any camera and extended stats, and delete the node
	main.current_blobs -= 1
	remove_from_group("blobs")
	remove_from_group("suitable_for_mating")
	selected = false
	var nodes = get_tree().get_nodes_in_group("blob_cameras")
	for node in nodes:
		node.get_parent().selected = false
		node.queue_free()
	main.get_node("Camera2D").enabled = true
	nodes = get_tree().get_nodes_in_group("extended_stats")
	for node in nodes:
		node.queue_free()
	
	queue_free()

func send_stats_to_main(i):
	 # Read stats and send them to main for averages
	main.stomach_capacities[i] = stomach_capacity
	main.starting_thirsts[i] = starting_thirst
	main.starting_rests[i] = starting_rest
	main.fats[i] = fat
	main.base_speeds[i] = base_speed
	main.sights[i] = sight

func _on_button_pressed() -> void:
	 # When blob clicked
	if selected == true:
		selected = false
	else:
		selected = true
	
	if selected == true:
		 # Delete any other blob cameras, create a new camera on this blob, and make it the active one
		var nodes = get_tree().get_nodes_in_group("blob_cameras")
		for node in nodes:
			node.get_parent().selected = false
			node.queue_free()
		var camera = Camera2D.new()
		camera.add_to_group("blob_cameras")
		add_child(camera)
		main.get_node("Camera2D").enabled = false
		 # Delete any other blobs extended stats
		nodes = get_tree().get_nodes_in_group("extended_stats")
		for node in nodes:
			node.queue_free()
		
		 # Show this blobs extended stats
		var stat_box = MeshInstance2D.new()
		stat_box.mesh = load("res://stat_box.tres")
		stat_box.modulate = $MeshInstance2D.modulate
		var extended_stats = Label.new()
		extended_stats.name = "Extended Stats"
		extended_stats.size = Vector2(120, 23)
		extended_stats.position = Vector2(81, 74)
		update_extended_stats(extended_stats)
		stat_box.add_to_group("extended_stats")
		extended_stats.add_to_group("extended_stats")
		canvas_layer.add_child(stat_box)
		canvas_layer.add_child(extended_stats)
		selected = true
	else:
		 # Make main camera active again
		var nodes = get_tree().get_nodes_in_group("blob_cameras")
		for node in nodes:
			node.queue_free()
		main.get_node("Camera2D").enabled = true
		 # Get rid of extended stats
		nodes = get_tree().get_nodes_in_group("extended_stats")
		for node in nodes:
			node.queue_free()
		selected = false
