extends Node

func _ready() -> void:
	 # Hide pause interface
	$"../CanvasLayer/PausedLabel".visible = false
	$"../CanvasLayer/ResumeButton".visible = false
	$"../CanvasLayer/MainMenuButton".visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") == true:
		 # If P pressed, show pause interface, and pause game
		$"../CanvasLayer/PausedLabel".visible = true
		$"../CanvasLayer/ResumeButton".visible = true
		$"../CanvasLayer/MainMenuButton".visible = true
		get_parent().script_paused = true
		get_tree().paused = true

func _on_resume_button_pressed() -> void:
	 # If resume button pressed, unpause game, and hide pause inerface
	get_parent().script_paused = false
	get_tree().paused = false
	$"../CanvasLayer/PausedLabel".visible = false
	$"../CanvasLayer/ResumeButton".visible = false
	$"../CanvasLayer/MainMenuButton".visible = false

func _on_main_menu_button_pressed() -> void:
	 # If main menu button pressed, unpause, reload the game
	get_tree().paused = false
	get_tree().reload_current_scene()
