extends CanvasLayer

func _ready() -> void:
	scale = Vector2(1.3, 1.3);
	offset = get_viewport().get_visible_rect().size / 2;
	Seed.player_scene.process_mode = Node.PROCESS_MODE_DISABLED;
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED;


func _on_continue_button_down() -> void:
	queue_free();
	Seed.player_scene.process_mode = Node.PROCESS_MODE_INHERIT;
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT;




func _on_titlescreen_button_down() -> void:
	Seed.SEED = randi();
	Seed.player_has_pos = false;
	Seed.player_scene.free();
	queue_free();
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn");
