extends CanvasLayer

func _ready() -> void:
	scale = Vector2(1.3, 1.3);
	offset = get_viewport().get_visible_rect().size / 2;
	PlayerManager.player_.process_mode = Node.PROCESS_MODE_DISABLED;
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED;
	
	$titlescreen.scale(Vector2(1.5, 1.5) / scale);
	$titlescreen.pressed.connect(_on_titlescreen_button_pressed);
	$titlescreen.set_text("TITLESCREEN");
	$continue.scale(Vector2(1.5, 1.5) / scale);
	$continue.pressed.connect(_on_continue_button_pressed);
	$continue.set_text("CONTINUE");

func _on_continue_button_pressed() -> void:
	queue_free();
	PlayerManager.player_.process_mode = Node.PROCESS_MODE_INHERIT;
	get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT;

func _on_titlescreen_button_pressed() -> void:
	PlayerManager.player_.free()
	queue_free();
	get_tree().change_scene_to_file("res://scenes/titlescreen.tscn");
