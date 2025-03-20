extends Node2D

 # Define variables
var starting_blobs : int
var starting_plants : int
var starting_ponds : int
 # Define scenes
var blob_scene = preload("res://scenes/blob.tscn")
var plant_scene = preload("res://scenes/plant.tscn")
var pond_scene = preload("res://scenes/pond.tscn")
var global_blob_count = 0
var current_blobs = 0
 # Create average variables for future use
var stomach_capacities : Dictionary
var starting_thirsts : Dictionary
var starting_rests : Dictionary
var fats : Dictionary
var base_speeds : Dictionary
var sights : Dictionary
var avg_stomach_capacity : Dictionary
var avg_starting_thirst : Dictionary
var avg_starting_rest : Dictionary
var avg_fat : Dictionary
var avg_base_speed : Dictionary
var avg_sight : Dictionary
var script_paused = false
var avg_starting_stomach_capacity : float
var avg_starting_starting_thirst : float
var avg_starting_starting_rest : float
var avg_starting_base_speed : float
var avg_starting_sight : float
var stat_variation_multiplier : float
var starting_fat : float
var plant_hunger_value : float
var pond_thirst_value : float
var blob_names : Dictionary
var blob_generations : Dictionary
var highest_generation
var time : float # In seconds
var all_blob_stats : bool = false
var active_stat = 1
var blob_adulthood : float
var blob_maximum_birth_age : float
var blob_life_expectency : float

var wind_direction = randf_range(0.0, 360.0)
var wind_speed = randi_range(0, 150)

func _ready() -> void:
	 # Create starting blobs
	for i in starting_blobs:
		global_blob_count += 1
		var blob = blob_scene.instantiate()
		blob.position = Vector2(randf_range(-576, 576), randf_range(-324, 324))
		var sprite = blob.get_node("Sprite")
		blob.base_color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
		sprite.modulate = blob.base_color
		blob.set_name("Blob_%d" % global_blob_count)
		blob.generation = 0
		blob.hunger = avg_starting_stomach_capacity
		blob.thirst = avg_starting_starting_thirst
		blob.rest = avg_starting_starting_rest
		blob.base_speed = avg_starting_base_speed
		blob.sight = avg_starting_sight
		blob.variation_multiplier = stat_variation_multiplier
		blob.fat = starting_fat
		blob.adulthood = blob_adulthood
		blob.maximum_children = blob_maximum_birth_age
		blob.life_expectency = blob_life_expectency
		add_child(blob)
	
	 # Create starting plants
	for i in starting_plants:
		var plant = plant_scene.instantiate()
		plant.position = Vector2(randf_range(-576, 576), randf_range(-324, 324))
		plant.full_hunger_value = plant_hunger_value
		plant.variation_multiplier = stat_variation_multiplier
		add_child(plant)
	
	 # Create starting ponds
	for i in starting_ponds:
		var pond = pond_scene.instantiate()
		pond.position = Vector2(randf_range(-556, 556), randf_range(-304, 304))
		pond.thirst_value = pond_thirst_value
		pond.set_name("Pond_%d" % i)
		add_child(pond)
	
	read_avg_stats()
	
	update_plant_wind()
	
	change_wind_speed()
	
	change_wind_direction()

func read_avg_stats():
	var times_done = -1
	while true:
		 # If the game isn't paused, continue
		if script_paused == false:
			 # Wait one second
			await get_tree().create_timer(1).timeout
			times_done += 1
			 # Clear previous values
			stomach_capacities.clear()
			starting_thirsts.clear()
			starting_rests.clear()
			fats.clear()
			base_speeds.clear()
			sights.clear()
			blob_names.clear()
			 # Read stats of all blobs
			var nodes = get_tree().get_nodes_in_group("blobs")
			var i = -1
			for node in nodes:
				i += 1
				node.send_stats_to_main(i)
			
			current_blobs = blob_names.size()
			
			 # Calc and display average stomach capacity
			var length = stomach_capacities.size()
			var temp = 0
			for x in length:
				temp += stomach_capacities[x]
			avg_stomach_capacity[times_done] = temp / length
			$CanvasLayer/Avg_Stats.text = "Avg Stomach Capacity: " + String("%0.3f" % avg_stomach_capacity[times_done])
			
			 # Calc and display average starting thirst
			length = starting_thirsts.size()
			temp = 0
			for x in length:
				temp += starting_thirsts[x]
			avg_starting_thirst[times_done] = temp / length
			$CanvasLayer/Avg_Stats.text += "\nAvg Starting Thirst: " + String("%0.3f" % avg_starting_thirst[times_done])
			
			 # Calc and display average starting rest
			length = starting_rests.size()
			temp = 0
			for x in length:
				temp += starting_rests[x]
			avg_starting_rest[times_done] = temp / length
			$CanvasLayer/Avg_Stats.text += "\nAvg Starting Rest: " + String("%0.3f" % avg_starting_rest[times_done])
			
			 # Calc and display average fat
			length = fats.size()
			temp = 0
			for x in length:
				temp += fats[x]
			avg_fat[times_done] = temp / length
			$CanvasLayer/Avg_Stats.text += "\nAvg Fat: " + String("%0.3f" % avg_fat[times_done])
			
			 # Calc and display average base speed
			length = base_speeds.size()
			temp = 0
			for x in length:
				temp += base_speeds[x]
			avg_base_speed[times_done] = temp / length
			$CanvasLayer/Avg_Stats.text += "\nAvg Base Speed: " + String("%0.3f" % avg_base_speed[times_done])
			
			 # Calc and display average sight
			length = sights.size()
			temp = 0
			for x in length:
				temp += sights[x]
			avg_sight[times_done] = temp / length
			$CanvasLayer/Avg_Stats.text += "\nAvg Sight: " + String("%0.3f" % avg_sight[times_done])
			
			length = blob_generations.size()
			highest_generation = 0
			for x in length:
				if blob_generations[x] > highest_generation:
					highest_generation = blob_generations[x]
			$CanvasLayer/Avg_Stats.text += "\nHighest Generation: " + str(highest_generation)
			
			if time < 60:
				$CanvasLayer/Avg_Stats.text += "\nTime: " + String("%0.3f" % time) + " Seconds"
			elif time < 3600:
				$CanvasLayer/Avg_Stats.text += "\nTime: " + String("%0.3f" % (time / 60)) + " Minutes"
			else:
				$CanvasLayer/Avg_Stats.text += "\nTime: " + String("%0.3f" % (time / 3600)) + " Hours"
			
		else:
			 # If it is paused, wait 1 frame to before checking if it isn't to avoid lag
			await get_tree().create_timer(0).timeout

func _process(delta: float) -> void:
	 # Update blob and blobs ever count
	time += delta
	$CanvasLayer/BlobsEver.text = "Blobs Ever: " + str(global_blob_count)
	$CanvasLayer/Blobs.text = "Blobs: " + str(current_blobs)
	if Input.is_action_just_pressed("All_Blobs_Stats"):
		if all_blob_stats == false:
			all_blob_stats = true
		else:
			all_blob_stats = false
	if all_blob_stats == true:
		if Input.is_action_just_pressed("All_Blob_Stat_+"):
			active_stat += 1
			if active_stat > 14:
				active_stat = 1
		if Input.is_action_just_pressed("All_Blob_Stat_-"):
			active_stat -= 1
			if active_stat < 1:
				active_stat = 14

func change_wind_speed():
	while true:
		await get_tree().create_timer(randf_range(5, 10)).timeout # Change wind every 5-10 seconds
		var change_dir = 1 if randi_range(1, 2) == 1 else -1 # Pick to make speed go up or down
		var change_amount = randf_range(10, 150)
		for i in change_amount: # Speed up/slow down over time
			await get_tree().create_timer(0.03333).timeout
			wind_speed += change_dir
			wind_speed = clamp(wind_speed, 0, 300) # Stop from going to slow or to fast
			update_plant_wind()

func change_wind_direction():
	while true:
		await get_tree().create_timer(randf_range(5, 10)).timeout # Change wind every 5-10 seconds
		var change_dir = 1 if randi_range(1, 2) == 1 else -1 # Pick to make direction go up or down
		var change_amount = randf_range(15, 90)
		for i in change_amount: # Go up/go down over time
			await get_tree().create_timer(0.03333).timeout
			wind_direction += change_dir
			wind_direction = clamp(wind_direction, 0, 360) # Stop from going to far or negative
			update_plant_wind()

func update_plant_wind():
	var wind_dir_radians = deg_to_rad(wind_direction)
	var wind_dir_vec2 = Vector2(cos(wind_dir_radians), sin(wind_dir_radians))
	var nodes = get_tree().get_nodes_in_group("sways_in_wind")
	for node in nodes: # Update plants wind sway shader with new speed
		if node is Sprite2D:
			node.material.set_shader_parameter("wind_speed", wind_speed)
			node.material.set_shader_parameter("wind_dir", wind_dir_vec2)
		else:
			node.get_node("Sprite").material.set_shader_parameter("wind_speed", wind_speed)
			node.get_node("Sprite").material.set_shader_parameter("wind_dir", wind_dir_vec2)
