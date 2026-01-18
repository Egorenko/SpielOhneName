extends Node2D

@export var RoomsOptions: Array[PackedScene] = [];
var Rooms: Array[Dungeon_Room] = [];
var dungeon_size: int = 6; #for more than 6 it takes too much time to load
var dungeon_density: float = 0.4;
var randomIteration: int = 0;
var current_room: Dungeon_Room;
var MaxRoomSize: Vector2i = Vector2i(30, 30);
var MinRoomSize: Vector2i = Vector2i(6, 8);

func _ready() -> void:
	var player = PlayerManager.get_player()
	if player.get_parent():
		player.get_parent().remove_child(player)
	await get_tree().process_frame
	add_child(player)
	
	var Matrix: Array[bool] = generate_dungeon_layout(dungeon_size, dungeon_density);
	var Matrix2: Array[int] = assign_indices_to_rooms(Matrix);
	generate_rooms(Matrix2);
	change_room(0);
	$player.can_teleport = false;
	$player.global_position = Rooms[0].get_teleport_tile_global_pos(2);
	$Camera2D.make_current();
	
func _process(delta: float) -> void:
	var teleportIndex: int = current_room.is_pos_on_teleporter($player.global_position);	
	if (teleportIndex < 0): 
		$player.can_teleport = true;
		return;
	if ($player.can_teleport and teleportIndex == 4):
		$player.can_teleport = false;
		get_tree().change_scene_to_file("res://scenes/map.tscn");
		return;
	if ($player.can_teleport && teleportIndex >= 0):
		var playerNewPos: Vector2i = Rooms[current_room.tileMap.NeigbourRoomIndices[teleportIndex]].get_teleport_tile_global_pos(teleportIndex);
		change_room(current_room.tileMap.NeigbourRoomIndices[teleportIndex]);
		$player.global_position = playerNewPos;
		$player.can_teleport = false;

func random(SEED: int) -> int:
	randomIteration += 1;
	return (SEED + randomIteration)	* 16807 % 2147483647;
	
func change_room(RoomIndex: int) -> void:
	if (current_room != null):
		current_room.set_active(false);
		
	current_room = Rooms[RoomIndex];
	current_room.set_active(true);
	$Camera2D.roomRect = current_room.tileMap.get_room_rect();


func _input(event: InputEvent) -> void:
	if (Input.is_key_pressed(KEY_Q)):
		change_room(1);
		
		
func generate_dungeon_layout(size: int, density: float) -> Array[bool]:
	var Matrix: Array[bool];
	Matrix.resize(size * size);
	var room_count: int = 1;
	Matrix[size * size / 2] = true;
	while (room_count < size * size * density):
		var index: int = random($player.SEED) % (size * size);
		if (Matrix[index]): continue;
		var has_direct_neigbour = false;
		var pos: Vector2i = Vector2i(index % size, index / size);
		var count: int = 0;
		if (pos.x > 0): if (Matrix[index - 1]): 
			count += 1;
			has_direct_neigbour = true;
		if (pos.x < size - 1): if (Matrix[index + 1]): 
			count += 1;
			has_direct_neigbour = true;
		if (pos.y > 0): 
			if (Matrix[index - size]):
				count += 1;
				has_direct_neigbour = true;
			if (pos.x < size - 1): if (Matrix[index - size + 1]): count += 1;
			if (pos.x > 0): if (Matrix[index - size - 1]): count += 1;
		if (pos.y < size - 1): 
			if (Matrix[index + size]): 
				count += 1;
				has_direct_neigbour = true;
			if (pos.x < size - 1): if (Matrix[index + size + 1]): count += 1;
			if (pos.x > 0): if (Matrix[index + size - 1]): count += 1;
		if (count < 9 * density and has_direct_neigbour): 
			Matrix[index] = true;		
			room_count += 1;
	return Matrix;
	
func assign_indices_to_rooms(Matrix: Array[bool]) -> Array[int]:
	var size: int = Matrix.size();
	var index: int = 0;
	var output: Array[int] = [];
	output.resize(size);
	for i in range(0, size):
		if (Matrix[i]):
			output[i] = index;
			index += 1;
		else: output[i] = -1;
	return output;
	
func generate_rooms(Matrix: Array[int])-> void:
	for i in range(0, Matrix.size()):
		if (Matrix[i] < 0): continue;
		Rooms.append(RoomsOptions.pick_random().instantiate())
		add_child(Rooms[Matrix[i]]);
		var neibours: Vector4i = Vector4i(-1, -1, -1, -1);
		if (i % dungeon_size > 0): neibours[3] = Matrix[i - 1];
		if (i % dungeon_size < dungeon_size - 1): neibours[1] = Matrix[i + 1];
		if (i / dungeon_size > 0): neibours[0] = Matrix[i - dungeon_size];
		if (i / dungeon_size < dungeon_size - 1): neibours[2] = Matrix[i + dungeon_size];
		if (Matrix[i] == 0): Rooms[Matrix[i]].tileMap.hasLadder = true;
		Rooms[Matrix[i]].tileMap.generate(Vector2i(random($player.SEED) % (MaxRoomSize.x - MinRoomSize.x) + MinRoomSize.x, random($player.SEED) % (MaxRoomSize.y - MinRoomSize.y) + MinRoomSize.y), Vector2i(0, Matrix[i] * (MaxRoomSize.x + 6)), Matrix[i], neibours);
		Rooms[Matrix[i]].spawn_enemys(random($player.SEED) % 10);
	var finalRoom: int = random($player.SEED) % (Rooms.size() - 3) + 3;
	Rooms[finalRoom].tileMap.generate_specialCrate();
