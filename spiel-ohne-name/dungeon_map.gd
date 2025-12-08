extends TileMap

@onready
var Tilemap: TileMap = self;
var teleport_tiles: Array[Vector4i] = [];
var Structure_Dungeon_Room: TileMapPattern;

func _ready() -> void:
	save_structure(Vector4i(0, 0, 11, 9), "");
	var loaded_pattern_layer_0: TileMapPattern = ResourceLoader.load("res://structures/Structure_Dungeon_Room_1.0.tres")
	#var loaded_pattern_layer_1: TileMapPattern = ResourceLoader.load("res://structures/Structure_House_3.1.tres")
	for x in range(0, 25):
		for y in range(0, 25):
			Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(3, 0), 0);
	
	Tilemap.set_pattern(0, Vector2i(10, 10), loaded_pattern_layer_0);
	
	
	teleport_tiles.append(Vector4i(1, -2, 18, -2));
	teleport_tiles.append(Vector4i(18, -2, 1, -2));

	
	
	

func _process(delta: float) -> void:
	pass;
	
func save_structure(rect: Vector4i, path: String)-> void:
	var posarray = [];
	for i in range(rect[0], rect[0] + rect[2]):
		for j in range(rect[1], rect[1] + rect[3]):
			posarray.append(Vector2i(i, j));
	Structure_Dungeon_Room = Tilemap.get_pattern(0, posarray);
	ResourceSaver.save(Structure_Dungeon_Room, "res://structures/Structure_Dungeon_Room_1.0.tres");
	#Structure_Dungeon_Room = Tilemap.get_pattern(1, posarray);
	#ResourceSaver.save(Structure_Dungeon_Room, "res://structures/Structure_Dungeon_Room_1.1.tres");	
