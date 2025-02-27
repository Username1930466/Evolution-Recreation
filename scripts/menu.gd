extends Node2D

var main_scene = preload("res://scenes/main.tscn")

func _ready() -> void:
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
	$MenuVisuals.queue_free()
	var main = main_scene.instantiate()
	add_child(main)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
