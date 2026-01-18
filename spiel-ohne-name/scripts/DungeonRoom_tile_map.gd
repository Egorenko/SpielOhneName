extends TileMap

@onready var player:player1 = Seed.player_scene;

@export var chest: PackedScene;
@export var crate: PackedScene;
var NeigbourRoomIndices: Vector4i = Vector4i(1, 1, 1, 1); # up, right, down, left
var doorPositions: Array[Vector2i] = [Vector2i(), Vector2i(), Vector2i(), Vector2i()];
var RoomSize: Vector2i = Vector2i(10, 10);
var RoomPos: Vector2i = Vector2i(0, 0);
var RoomRect: Vector4i = Vector4i(0, 0, 0, 0); #beginX, BeginY, sizeX, sizeY
var RoomID: int = 0;
var randomIteration: int = 0;
var hasLadder: bool = false;


func _ready() -> void:
	pass
	
func generate(Room_Size: Vector2i, Room_pos: Vector2i, Room_ID: int, NeigRoInd: Vector4i) -> void:
	RoomSize = Room_Size;
	RoomID = Room_ID;
	NeigbourRoomIndices = NeigRoInd;
	RoomPos = Room_pos;
	var sceneSize = determine_canvas_size();
	RoomRect = Vector4i((sceneSize.x - RoomSize.x) / 2 + RoomPos.x, (sceneSize.y - RoomSize.y) / 2 + 3 + RoomPos.y, RoomSize.x, RoomSize.y);
	for x in range(RoomPos.x, sceneSize.x + RoomPos.x):
		for y in range(RoomPos.y, sceneSize.y + 3 + RoomPos.y):
			set_cell(0, Vector2i(x, y), 0, Vector2i(3, 0), 0);
			if (x >= RoomRect.x and x < RoomSize.x + RoomRect.x):
				if (y >= RoomRect.y - 3 and y < RoomRect.y):
					set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0);
				if (y >= RoomRect.y and y < RoomSize.y + RoomRect.y):
					set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0), 0);
	#place doors
	if (NeigbourRoomIndices[0] != -1 or hasLadder):
		var a = random(RoomID + player.SEED + 0) % (RoomRect[2] - 2) + 1;
		if (hasLadder):
			set_cell(1, Vector2i(RoomRect[0] + a, RoomRect[1]), 0, Vector2i(5, 0), 0);
			set_cell(1, Vector2i(RoomRect[0] + a, RoomRect[1] - 1), 0, Vector2i(5, 0), 0);
			set_cell(1, Vector2i(RoomRect[0] + a, RoomRect[1] - 2), 0, Vector2i(5, 0), 0);
			doorPositions[0] = Vector2i(RoomRect[0] + a, RoomRect[1]);
		else:
			set_cell(1, Vector2i(RoomRect[0] + a, RoomRect[1]), 0, Vector2i(6, 0), 0);
			doorPositions[0] = Vector2i(RoomRect[0] + a, RoomRect[1]);
	if (NeigbourRoomIndices[1] != -1):
		var a = random(RoomID + player.SEED + 1) % (RoomRect[3] - 2) + 1;
		set_cell(1, Vector2i(RoomRect[0] + RoomRect[2] - 1, RoomRect[1] + a), 0, Vector2i(4, 0), 0);
		doorPositions[1] = Vector2i(RoomRect[0] + RoomRect[2] - 1, RoomRect[1] + a);
	if (NeigbourRoomIndices[2] != -1):
		var a = random(RoomID + player.SEED + 2) % (RoomRect[2] - 2) + 1;
		set_cell(1, Vector2i(RoomRect[0] + a, RoomRect[1] + RoomRect[3] - 1), 0, Vector2i(4, 1), 0);
		doorPositions[2] = Vector2i(RoomRect[0] + a, RoomRect[1] + RoomRect[3] - 1);
	if (NeigbourRoomIndices[3] != -1):
		var a = random(RoomID + player.SEED + 3) % (RoomRect[3] - 2) + 1;
		set_cell(1, Vector2i(RoomRect[0], RoomRect[1] + a), 0, Vector2i(4, 2), 0);
		doorPositions[3] = Vector2i(RoomRect[0], RoomRect[1] + a);
	
	if (random(player.SEED) % 50 < 30):
		generate_random_pillars();
	if (random(player.SEED) % 50 < 30):
		generate_random_holes();
	generate_chest();
	generate_crate();		
			
func determine_canvas_size() -> Vector2i:
	var output: Vector2i = RoomSize;
	if (RoomSize.x < 25): output.x = 25;
	if (RoomSize.y < 15): output.y = 15;
	output += Vector2i(2, 2);
	return output;		
	
func get_room_rect() -> Vector4:
	var a = Vector2(RoomRect[0], RoomRect[1] - 3);
	var b = Vector2(RoomRect[2], RoomRect[3] + 3);
	a = to_global(map_to_local(a));
	b = to_global(map_to_local(b));
	return Vector4(a.x, a.y ,b.x, b.y);
	
func random(SEED: int) -> int:
	randomIteration += 1;
	return (SEED + randomIteration)	* 16807 % 2147483647;
	
func generate_random_pillars() -> void:
	var num: Vector2i = Vector2i(random(player.SEED) % 6 + 1, random(player.SEED) % 6 + 1);
	if (num.x > RoomSize.x / 6): num.x = RoomSize.x / 6;
	if (num.y > RoomSize.y / 6): num.y = RoomSize.y / 6;
	for x in range(1, num.x + 1):
		for y in range(1, num.y + 1):
			var pos: Vector2i = Vector2i(RoomRect[0] + x * (RoomRect[2] / (num.x + 1)), RoomRect[1] + y * (RoomRect[3] / (num.y + 1)));
			if (random(player.SEED) % 50 < 5):
				set_cell(0, pos, 0, Vector2i(1, 2), 0);
				continue
			if (random(player.SEED) % 50 < 5):
				continue
			set_cell(0, pos, 0, Vector2i(0, 2), 0);
			set_cell(2, Vector2i(pos.x, pos.y - 1), 0, Vector2i(0, 1), 0);
			set_cell(2, Vector2i(pos.x, pos.y - 2), 0, Vector2i(1, 1), 0);
	
func generate_random_holes() -> void:
	var count: int = 100;
	var placed: int = 0;
	while (count > 0 and placed < 4):
		var pos: Vector2i = Vector2i(random(player.SEED) % (RoomRect[2] - 2) + RoomRect[0] + 1, random(player.SEED) % (RoomRect[3] - 2) + RoomRect[1] + 1);
		if (get_cell_atlas_coords(0, pos) == Vector2i(1, 0)):
			set_cell(0, pos, 0, Vector2i(2, 1), 0);
			placed += 1;
		count -= 1;
		
func generate_chest() -> void:
	var pos: Vector2i = Vector2i(random(player.SEED) % RoomRect[2] + RoomRect[0], random(player.SEED) % RoomRect[3] + RoomRect[1]);
	if (get_cell_atlas_coords(0, pos) == Vector2i(1, 0) and get_cell_atlas_coords(1, pos) == Vector2i(-1, -1)):
		var a = chest.instantiate();
		get_tree().current_scene.call_deferred_thread_group("add_child", a)
		a.position = map_to_local(pos);
		a.z_index = 3;
		
func generate_crate() -> void:
	var cluster: int = random(player.SEED) % 5;
	for i in range(0, cluster):
		var crateCount: int = random(player.SEED) % 5;
		var pos: Vector2i = Vector2i(random(player.SEED) % RoomRect[2] + RoomRect[0], random(player.SEED) % RoomRect[3] + RoomRect[1]);
		for j in range(0, crateCount):
			var a = crate.instantiate();
			get_tree().current_scene.call_deferred_thread_group("add_child", a)
			a.position = map_to_local(pos);
			a.position += Vector2(random(player.SEED) % 40 - 20, random(player.SEED) % 40 - 20);
			a.z_index = 3;
			
func generate_specialCrate() -> void:
	pass
