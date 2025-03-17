extends Node2D

var main_scene = preload("res://scenes/main.tscn")
var customization_menu : bool = false

func _ready() -> void:
	 # Randomly color the menu blobs
	var color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	$MenuVisuals/Blob.modulate = color
	color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	$MenuVisuals/Blob2.modulate = color
	color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	$MenuVisuals/Blob3.modulate = color
	color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	$MenuVisuals/Blob4.modulate = color
	color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	$MenuVisuals/Blob5.modulate = color
	color = Color(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1))
	$MenuVisuals/Blob6.modulate = color

func _on_play_button_pressed() -> void:
	 # Delete menu visuals and activate main
	$MenuVisuals.queue_free()
	var main = main_scene.instantiate()
	main.starting_blobs = $MenuVisuals/StartingBlobsChanger.text
	main.starting_plants = $MenuVisuals/StartingPlantsChanger.text
	main.starting_ponds = $MenuVisuals/StartingPondsChanger.text
	main.seconds_per_plant = $MenuVisuals/SecondsPerPlantChanger.text
	main.avg_starting_stomach_capacity = $MenuVisuals/AvgStomachCapacityChanger.text
	main.avg_starting_starting_thirst = $MenuVisuals/AvgStartingThirstChanger.text
	main.avg_starting_starting_rest = $MenuVisuals/AvgStartingRestChanger.text
	main.avg_starting_base_speed = $MenuVisuals/AvgBaseSpeedChanger.text
	main.avg_starting_sight = $MenuVisuals/AvgSightChanger.text
	main.stat_variation_multiplier = $MenuVisuals/StatVariationMultiplierChanger.text
	main.starting_fat = $MenuVisuals/StartingFatChanger.text
	main.plant_hunger_value = $MenuVisuals/PlantHungerValueChanger.text
	main.pond_thirst_value = $MenuVisuals/PondThirstValueChanger.text
	main.blob_adulthood = $MenuVisuals/AdulthoodChanger.text
	main.blob_maximum_birth_age = $MenuVisuals/MaximumBirthAgeChanger.text
	main.blob_life_expectency = $MenuVisuals/LifeExpectencyChanger.text
	add_child(main)

func _on_quit_button_pressed() -> void:
	 # Quit the game
	get_tree().quit()

func _on_customize_button_pressed() -> void:
	if customization_menu == false:
		customization_menu = true
		$MenuVisuals/CustomizeButton.position = Vector2(825, 574)
		$MenuVisuals/CustomizeButton.text = "Leave Menu"
		$MenuVisuals/CustomizeButton.add_theme_font_size_override("font_size", 23)
		$MenuVisuals/CustomizationMenu.visible = true
		$MenuVisuals/CustomizationText.visible = true
		$MenuVisuals/StartingBlobsChanger.visible = true
		$MenuVisuals/StartingPlantsChanger.visible = true
		$MenuVisuals/StartingPondsChanger.visible = true
		$MenuVisuals/SecondsPerPlantChanger.visible = true
		$MenuVisuals/AvgStomachCapacityChanger.visible = true
		$MenuVisuals/AvgStartingThirstChanger.visible = true
		$MenuVisuals/AvgStartingRestChanger.visible = true
		$MenuVisuals/AvgBaseSpeedChanger.visible = true
		$MenuVisuals/AvgSightChanger.visible = true
		$MenuVisuals/StatVariationMultiplierChanger.visible = true
		$MenuVisuals/StartingFatChanger.visible = true
		$MenuVisuals/PlantHungerValueChanger.visible = true
		$MenuVisuals/PondThirstValueChanger.visible = true
		$MenuVisuals/AdulthoodChanger.visible = true
		$MenuVisuals/MaximumBirthAgeChanger.visible = true
		$MenuVisuals/LifeExpectencyChanger.visible = true
	else:
		customization_menu = false
		$MenuVisuals/CustomizeButton.position = Vector2(504, 366)
		$MenuVisuals/CustomizeButton.text = "Customize"
		$MenuVisuals/CustomizeButton.add_theme_font_size_override("font_size", 27)
		$MenuVisuals/CustomizationMenu.visible = false
		$MenuVisuals/CustomizationText.visible = false
		$MenuVisuals/StartingBlobsChanger.visible = false
		$MenuVisuals/StartingPlantsChanger.visible = false
		$MenuVisuals/StartingPondsChanger.visible = false
		$MenuVisuals/SecondsPerPlantChanger.visible = false
		$MenuVisuals/AvgStomachCapacityChanger.visible = false
		$MenuVisuals/AvgStartingThirstChanger.visible = false
		$MenuVisuals/AvgStartingRestChanger.visible = false
		$MenuVisuals/AvgBaseSpeedChanger.visible = false
		$MenuVisuals/AvgSightChanger.visible = false
		$MenuVisuals/StatVariationMultiplierChanger.visible = false
		$MenuVisuals/StartingFatChanger.visible = false
		$MenuVisuals/PlantHungerValueChanger.visible = false
		$MenuVisuals/PondThirstValueChanger.visible = false
		$MenuVisuals/AdulthoodChanger.visible = false
		$MenuVisuals/MaximumBirthAgeChanger.visible = false
		$MenuVisuals/LifeExpectencyChanger.visible = false
