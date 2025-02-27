extends Node2D

 # Define variables
@export var starting_blobs = 20
@export var starting_plants = 20
@export var starting_ponds = 10
@export var seconds_per_plant = 1
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

func _ready() -> void:
	 # Create starting blobs
	for i in starting_blobs:
		global_blob_count += 1
		var blob = blob_scene.instantiate()
		blob.position = Vector2(randf_range(-576, 576), randf_range(-324, 324))
		var sprite = blob.get_node("Sprite")
		sprite.modulate = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
		blob.set_name("Blob_%d" % global_blob_count)
		add_child(blob)
	
	 # Create starting plants
	for i in starting_plants:
		var plant = plant_scene.instantiate()
		plant.position = Vector2(randf_range(-576, 576), randf_range(-324, 324))
		add_child(plant)
	
	 # Create starting ponds
	for i in starting_ponds:
		var pond = pond_scene.instantiate()
		pond.position = Vector2(randf_range(-576, 576), randf_range(-324, 324))
		add_child(pond)
	
	spawn_plants_infinite()
	
	read_avg_stats()
	

func spawn_plants_infinite():
	while true:
		 # If the game isn't paused, create a plant every (seconds per plant) seconds
		if script_paused == false:
			await get_tree().create_timer(seconds_per_plant).timeout
			var plant = plant_scene.instantiate()
			plant.position = Vector2(randf_range(-576, 576), randf_range(-324, 324))
			add_child(plant)
		else:
			 # If it is paused, wait 1 frame to before checking if it isn't to avoid lag
			await get_tree().create_timer(0).timeout

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
			 # Read stats of all blobs
			var nodes = get_tree().get_nodes_in_group("blobs")
			var i = -1
			for node in nodes:
				i += 1
				node.send_stats_to_main(i)
			
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
		else:
			 # If it is paused, wait 1 frame to before checking if it isn't to avoid lag
			await get_tree().create_timer(0).timeout

func _process(delta: float) -> void:
	 # Update blob and blobs ever count
	$CanvasLayer/BlobsEver.text = "Blobs Ever: " + str(global_blob_count)
	$CanvasLayer/Blobs.text = "Blobs: " + str(current_blobs)
