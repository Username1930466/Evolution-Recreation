extends Node

func _ready() -> void:
	$"../CanvasLayer/PausedLabel".visible = false
	$"../CanvasLayer/ResumeButton".visible = false
	$"../CanvasLayer/MainMenuButton".visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") == true:
		$"../CanvasLayer/PausedLabel".visible = true
		$"../CanvasLayer/ResumeButton".visible = true
		$"../CanvasLayer/MainMenuButton".visible = true
		get_parent().script_paused = true
		get_tree().paused = true

func _on_resume_button_pressed() -> void:
	get_parent().script_paused = false
	get_tree().paused = false
	$"../CanvasLayer/PausedLabel".visible = false
	$"../CanvasLayer/ResumeButton".visible = false
	$"../CanvasLayer/MainMenuButton".visible = false

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
