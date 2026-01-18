extends CanvasLayer


func _ready() -> void:
	var camera: Camera2D = get_viewport().get_camera_2d();
	if (camera == null): return;
	#position = camera.position;
	scale = Vector2(1.3, 1.3);
	offset = get_viewport().get_visible_rect().size / 2;

func _on_new_game_button_button_down() -> void:
	Seed.SEED = randi();
	Seed.player_has_pos = false;
	queue_free();
	get_tree().change_scene_to_file("res://scenes/map.tscn");


func _on_titlescreen_button_button_up() -> void:
	Seed.SEED = randi();
	Seed.player_has_pos = false;
	queue_free();
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn");
