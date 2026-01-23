extends Node2D

func _ready() -> void:
	
	$Credits.scale(Vector2(1.5, 1.5));
	$Credits.pressed.connect(_on_credits_button_pressed);
	$Credits.set_text("CREDITS");
	
	$Tutorial.scale(Vector2(1.5, 1.5));
	$Tutorial.pressed.connect(_on_tutorial_button_pressed);
	$Tutorial.set_text("TUTORIAL");
	
	$StartGame.scale(Vector2(1.5, 1.5));
	$StartGame.pressed.connect(_on_startgame_button_pressed);
	$StartGame.set_text("START GAME");


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn");
	
func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn");
	
func _on_startgame_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn");
