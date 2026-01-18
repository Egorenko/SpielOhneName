extends Node2D

@onready var TextBox: Node2D = $"./player/DialogBox";
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


func _ready() -> void:
	TextBox.visible = true;
	TextBox.reset();
	TextBox.Prompt = "Welcome to the tutorial. Press enter to continue";
	pass
	
func _process(delta: float) -> void:
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
	pass
	
func phase_0() -> void:
	var text: Array[String] = ["Using WASD you can move around. Give it a try."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_wasd):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
	
	
func phase_1() -> void:
	var text: Array[String] = ["Fantastic!", "Now... a chest should have just appeared to your top left. Try clicking on it."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		key_pressed_enter = false;
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		if (textnum == 1):
			chestInstance = chest.instantiate();
			get_tree().current_scene.add_child(chestInstance);
			chestInstance.position = $TileMap.map_to_local(Vector2i(-7, -4));
			chestInstance.z_index = 5;
	if (chestInstance != null and chestInstance.is_open):
		key_pressed_enter = true;
		phase += 1;
		textnum = 0;
		key_pressed_alt = false;
		
func phase_2() -> void:
	var text: Array[String] = ["Awesome.", "An item should have appeared. Pick it up and press Alt to open your inventory"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_alt):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		key_pressed_alt = false;
		
func phase_3() -> void:
	var text: Array[String] = ["Good job.", "We have nothing really important in here as of now but maybe we can find something nice later. Now please press Alt again to close your inventory."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_alt):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		key_pressed_alt = false;
		
func phase_4() -> void:
	var text: Array[String] = ["Awesome", "But chests aren't the only thing we have. We also have crates like the one you can see to your top right.", "You will have to attack those in order to destroy them and collect their precious contents.", "You will attack using your mouse. Hold left-clickand draw your attack. Once you have drawn your shape, release left-click", "First a basic one: A straigh forward attack. For that draw a line in the direction you want to attack starting in front of your character."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
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
	var text: Array[String] = ["Nice", "You can also draw a curve in front of your character in order to execute a swing that can hit multiple enemys for less dammage. I will provide you with another crate so you can try it out if you want to."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
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
	var text: Array[String] = ["Allright. As you can see crates drop items. Mostly healing items.", "You might want to enter your inventoy and select one by pressing left-click while hovering over the item. Once selected you can use the item by pressing E."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_e and key_pressed_enter and textnum + 1 >= text.size()):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		$player.sprint_on = false;
		$player.stats.speed = 15000;
		key_pressed_shift = false;
		
func phase_7() -> void:
	var text: Array[String] = ["Oh, before i forget it... you can also sprint by pressing and holding Shift."];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
	if (key_pressed_shift):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		
func phase_8() -> void:
	var text: Array[String] = ["Anyways... We are almost done. There are only two more things.", "First: There will obviously be enemys. You didn't think this was just going to be you alone in here, did you?", "Once you are ready, i will summon two enemys below you. One to your left and one to your right.", "For our defense you can also summon a shield that will protect you from some damage. For that you will have to draw a straight line horizontally in front of your character.","Ready?"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
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
		knight = enemys.instantiate();
		get_tree().current_scene.add_child(knight);
		knight.position = $TileMap.map_to_local(Vector2i(8 ,1));
		knight.z_index = 1;
		TextBox.visible = false;
		$"./player/Hurtbox".collision_layer = 1 << 4;
		
func phase_9() -> void:
	if (skeleton == null and knight == null):
		phase += 1;
		textnum = 0;
		key_pressed_enter = true;
		TextBox.visible = true;

		
func phase_10() -> void:
	if (can_finish):
		print("Door enabled");
		var a = $TileMap.get_cell_atlas_coords(1, $TileMap.local_to_map($player.position));
		if (a == Vector2i(8, 0)):
			get_tree().change_scene_to_file("res://scenes/titlescreen.tscn");
	var text: Array[String] = ["You are lucky that you are invincible in here. Never the less, well done.", "The second i mentioned is right in front of you. You see that House? Move up to it and you shall be set free.", "Have fun \nc:"];
	if (key_pressed_enter and TextBox.Text_completely_displayed and textnum < text.size()):
		TextBox.reset();
		TextBox.Prompt = text[textnum];
		textnum += 1;
		key_pressed_enter = false;
		if (textnum == 2):
			can_finish = true;
	if (textnum - 1 >= text.size()):
		textnum -= 1;
		key_pressed_enter = true;
	
	


func _input(event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_ENTER)):
		key_pressed_enter = true;
	if (Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_D)):
		key_pressed_wasd = true;
	if (Input.is_key_pressed(KEY_ALT)):
		key_pressed_alt = true;
	if (Input.is_key_pressed(KEY_E)):
		key_pressed_e = true;
	if (Input.is_key_pressed(KEY_SHIFT)):
		key_pressed_shift = true;
