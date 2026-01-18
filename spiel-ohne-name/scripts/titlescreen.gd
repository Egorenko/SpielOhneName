extends Node2D

func _on_button_button_down() -> void:
	if (Seed.player_scene == null): Seed.player_scene = preload("res://scenes/player.tscn").instantiate(); 
	get_tree().root.add_child.call_deferred(Seed.player_scene);
	Seed.player_scene.z_index = 1;
	Seed.player_scene.inventory.clear();
	get_tree().change_scene_to_file("res://scenes/map.tscn");


func _on_credit_button_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn");


func _on_tutorial_button_button_down() -> void:
	if (Seed.player_scene == null): Seed.player_scene = preload("res://scenes/player.tscn").instantiate(); 
	get_tree().root.add_child.call_deferred(Seed.player_scene);
	Seed.player_scene.z_index = 1;
	Seed.player_scene.inventory.clear();
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn");
