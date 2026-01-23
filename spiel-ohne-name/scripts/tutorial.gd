extends Node2D

@onready var player_:player = PlayerManager.player_
@onready var TextBox: Node2D = PlayerManager.player_.get_node("DialogBox");
@export var chest: PackedScene = preload("res://scenes/chest1.tscn");
@export var crat: PackedScene = preload("res://scenes/crate1.tscn");
@export var enemys: PackedScene = preload("res://scenes/skelleton.tscn");
@export var enemyk: PackedScene = preload("res://scenes/ritter.tscn");

var phase: int = 0;
var textnum: int = 0;
var key_pressed_enter: bool = false;
var key_pressed_wasd: bool = false;
var key_pressed_alt: bool = false;
var key_pressed_e: bool = false;
var key_pressed_shift: bool = false;
var player_clicked: bool = false;
var crate_summoned: bool = false;
var can_finish: bool = true;
var chestInstance: Node;
var crateInstance: Node;
var skeleton: Node;
var knight: Node;

func _enter_tree() -> void:
	player_ = PlayerManager.get_player()
	if player_.get_parent():
		player_.get_parent().remove_child(player_)
	await get_tree().process_frame
	get_tree().current_scene.add_child(player_)

func _ready() -> void:
	TextBox.visible = true;
	TextBox.reset();
	TextBox.Prompt = "Welcome to the tutorial. Press enter to continue";
	player_.get_node("Camera2D").make_current();
	#print(player_.get_node("Camera2D").zoom);
	pass
	
func _process(_delta: float) -> void:
	match (phase):
		0: phase_0();
		1: phase_1();
		2: phase_2();
		3: phase_3();
		4: phase_4();
		5: phase_5();
		6: phase_6();
		7: phase_7();
		8: phase_8();
		9: phase_9();
		10:phase_10();
		11:phase_11();
	pass
	
func phase_0() -> void:
	if textnum == 0:
		player_.stats.health.decrease_hp(2, "durch");
		player_.healthbar.update();
	var text: Array[String] = ["Using WASD you can move around. Give it a try."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum], false);
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_wasd):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
	
	
func phase_1() -> void:
	var text: Array[String] = ["Fantastic!", "Now... a chest should have just appeared to your top left. Try clicking on it using LEFT-CLICK."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		key_pressed_enter = false;
		textnum += 1;
		if (textnum == 2):
			chestInstance = chest.instantiate();
			get_tree().current_scene.add_child(chestInstance);
			chestInstance.position = $TileMap.map_to_local(Vector2i(-7, -4));
			chestInstance.z_index = 5;
			TextBox.set_text(text[textnum - 1], false);
			return;
		TextBox.set_text(text[textnum - 1]);
	if (chestInstance != null and chestInstance.is_open):
		key_pressed_enter = true;
		phase += 1;
		textnum = 0;
		key_pressed_alt = false;
		
func phase_2() -> void:
	var text: Array[String] = ["Awesome.", "An item should have appeared. Pick it up and press ALT to open your inventory"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum]);
		if (textnum == 1): 		TextBox.set_text(text[textnum], false);
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_alt):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		key_pressed_alt = false;
		
func phase_3() -> void:
	var text: Array[String] = ["Good job.", "We have nothing really important in here as of now but maybe we can find something nice later. Now please press ALT again to close your inventory."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum]);
		if (textnum == text.size() - 1): TextBox.set_text(text[textnum], false);
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_alt):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		key_pressed_alt = false;
		
func phase_4() -> void:
	var text: Array[String] = ["Awesome", "But chests aren't the only thing we have. We also have crates like the one you can see to your top right.", "You will have to attack those in order to destroy them and collect their precious contents.", "You will attack using your mouse. Hold LEFT-CLICK and draw your attack. Once you have drawn your shape, release left-click", "First a basic one: A straigh forward attack. For that draw a line in the direction you want to attack starting in front of your character."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum]);
		if (textnum == text.size() - 1): TextBox.set_text(text[textnum], false);
		textnum += 1;
		key_pressed_enter = false;
		if (textnum == 2):
			crateInstance = crat.instantiate();
			get_tree().current_scene.add_child(crateInstance);
			crateInstance.position = $TileMap.map_to_local(Vector2i(6, -4));
			crateInstance.z_index = 5;
			crate_summoned = true;
	if (crate_summoned and crateInstance == null):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		crate_summoned = false;
		
func phase_5() -> void:
	var text: Array[String] = ["Nice", "You can also draw a curve in front of your character in order to execute a swing that can hit multiple enemys for less damage. I will provide you with another crate so you can try it out if you want to."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum]);
		textnum += 1;
		key_pressed_enter = false;
		if (textnum == 2):
			crateInstance = crat.instantiate();
			get_tree().current_scene.add_child(crateInstance);
			crateInstance.position = $TileMap.map_to_local(Vector2i(6, -4));
			crateInstance.z_index = 5;
	if (key_pressed_enter and textnum >= text.size()):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		key_pressed_e = false
		
func phase_6() -> void:
	var text: Array[String] = ["Trees and bushes such as the ones you see to your left and right right now can also give you some healing items when you approach them"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		if (textnum == 0):
			var appletree = preload("res://scenes/apple_tree1.tscn").instantiate();
			get_tree().current_scene.add_child(appletree);
			appletree.position = $TileMap.map_to_local(Vector2i(7, -1));
			var berrybush = preload("res://scenes/bush1.tscn").instantiate();
			get_tree().current_scene.add_child(berrybush);
			berrybush.position = $TileMap.map_to_local(Vector2i(-8, -1));
		TextBox.set_text(text[textnum], false);
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_enter and textnum >= text.size()):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		
func phase_7() -> void:
	var text: Array[String] = ["Alright. As you can see crates drop items. Mostly healing items.", "You might want to enter your inventoy and select one by pressing LEFT-CLICK while hovering over the item. Once selected you can use the item by pressing E."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum]);
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_e and key_pressed_enter and textnum + 1 >= text.size()):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		key_pressed_shift = false;
		
func phase_8() -> void:
	var text: Array[String] = ["Oh, before i forget it... you can also sprint by pressing and holding Shift."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.set_text(text[textnum]);
		if (textnum == text.size() - 1): TextBox.set_text(text[textnum], false);
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_shift):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		
func phase_9() -> void:
	var text: Array[String] = ["Anyways... We are almost done. There are only two more things.", "First: There will obviously be enemies. You didn't think this was just going to be you alone in here, did you?", "Once you are ready, I will summon two enemies below you. One to your left and one to your right.","Ready?"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_enter and textnum + 1 >= text.size()):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		skeleton = enemys.instantiate();
		get_tree().current_scene.add_child(skeleton);
		skeleton.position = $TileMap.map_to_local(Vector2i(-9 ,1));
		skeleton.z_index = 1;
		knight = enemyk.instantiate();
		get_tree().current_scene.add_child(knight);
		knight.position = $TileMap.map_to_local(Vector2i(8 ,1));
		knight.z_index = 1;
		TextBox.visible = false;
		player_.get_node("Hurtbox").collision_layer = 1 << 4;
		
func phase_10() -> void:
	if (skeleton == null and knight == null):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		TextBox.visible = true;

		
func phase_11() -> void:
	if (can_finish):
		var a = $TileMap.get_cell_atlas_coords(1, $TileMap.local_to_map(player_.position));
		if (a == Vector2i(8, 0)):
			player_.free();
			get_tree().change_scene_to_file("res://scenes/titlescreen.tscn");
			return;
	var text: Array[String] = ["You are lucky that you are invincible in here. Never the less, well done.", "The second I mentioned is right in front of you. You see that House? Move up to it and you shall be set free.", "Have fun \n :)"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size() or textnum == 0):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
		if (textnum == 2):
			can_finish = true;
	if (textnum - 1 >= text.size()):
		textnum -= 1;
		key_pressed_enter = true;
	
	


func _input(_event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_ENTER)):
		key_pressed_enter = true;
	else: key_pressed_enter = false;
	if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D)):
		key_pressed_wasd = true;
	if (Input.is_key_pressed(KEY_ALT)):
		key_pressed_alt = true;
	if (Input.is_key_pressed(KEY_E)):
		key_pressed_e = true;
	if (Input.is_key_pressed(KEY_SHIFT)):
		key_pressed_shift = true;
