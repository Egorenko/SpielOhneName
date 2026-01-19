extends Node

var player_scene: Node2D;

func make_new_Instance() -> void:
	if (player_scene != null): player_scene.free();
	player_scene = preload("res://scenes/player.tscn").instantiate(); 
	get_tree().root.add_child.call_deferred(player_scene);
	player_scene.z_index = 1;
	player_scene.inventory.clear();
	
func delete_Instance() -> void:
	if (player_scene != null): player_scene.free();
