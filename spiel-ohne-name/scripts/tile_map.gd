extends TileMap

@onready
var Tilemap: TileMap = self
var noise: FastNoiseLite;
var Structure_House: TileMapPattern;
var Overworld_map_radius: int = 50;
var PlayerSpawnTile: Vector2i = Vector2i(0, 0);

var GrassTile: Vector2i = Vector2i(7, 5);
var PathTile: Vector2i = Vector2i(6, 5);
var MossyPathTile: Vector2i = Vector2i(8, 3);
var TreeTileSlim: Vector2i = Vector2i(9, 8);
var TreeTileWide: Vector2i = Vector2i(0, 8);

var Structures: Array[Array] = [[Vector3i(0, 6, 7), "res://structures/House_1"], 
								[Vector3i(1, 7, 6), "res://structures/House_2"], 
								[Vector3i(2, 8, 7), "res://structures/House_3"], 
								[Vector3i(3, 11, 9), "res://structures/House_4"], 
								[Vector3i(4, 8, 7), "res://structures/House_5"], 
								[Vector3i(5, 6, 7), "res://structures/House_6"], 
								[Vector3i(6, 10, 13), "res://structures/House_7"], 
								[Vector3i(7, 7, 6), "res://structures/Dungeon_1"], 
								[Vector3i(8, 4, 4), "res://structures/Dungeon_2"], 
								[Vector3i(9, 11, 6), "res://structures/Dungeon_3"]];


func _ready() -> void:
	
	#save_structure(Vector4i(0, 1, 6, 8), "res://structures/House_1");
	#save_structure(Vector4i(7, 1, 7, 7), "res://structures/House_2");
	#save_structure(Vector4i(15, 1, 8, 8), "res://structures/House_3");
	#save_structure(Vector4i(24, 1, 11, 10), "res://structures/House_4");
	#save_structure(Vector4i(37, 1, 8, 8), "res://structures/House_5");
	#save_structure(Vector4i(46, 1, 6, 8), "res://structures/House_6");
	#save_structure(Vector4i(0, 10, 10, 14), "res://structures/House_7");

	#save_structure(Vector4i(15, 13, 7, 7), "res://structures/Dungeon_1");
	#save_structure(Vector4i(27, 15, 4, 5), "res://structures/Dungeon_2");
	#save_structure(Vector4i(35, 13, 11, 7), "res://structures/Dungeon_3");
	
	noise = init_SimplexNoise($"../player".SEED);
	
	var ChunkSize: int = 25; # Chunksize in Tiles
	var minDistanceFromBorder: float = 0.15; # distance the middle of the path should have to the border of the chunk in percent of tiles
	var maxWayAmplitude: float = 0.1; # Maximum amplitude the path should have in percent of tiles. Full amplitude is two times this value since it can add and subtract the max amplitude
	var maxWayWidth: float = 0.1; # maximum width of the path in percent of tiles. full width is two times this value for it can be added below and above the path
	
	#generate map
		#trees
	for x in range(-Overworld_map_radius - 32, Overworld_map_radius + 16):
		for y in range(-Overworld_map_radius - 16, Overworld_map_radius + 16):
			if (sqrt(x * x + y * y) > Overworld_map_radius + 7 * (noise.get_noise_3d(x * 0.7, y * 0.7, 10) + 0.3)):
				if (noise.get_noise_2d(x* 10, y * 10) < -0.8 + (noise.get_noise_2d(x * 0.2, y * 0.2) + 1.0) * 0.6):
					Tilemap.set_cell(1, Vector2i(x, y), 1, TreeTileWide, 0);
				else:
					Tilemap.set_cell(1, Vector2i(x, y), 1, TreeTileSlim, 0);
				Tilemap.set_cell(0, Vector2i(x, y), 1, GrassTile, 0);
				continue;
				
			#generate pathways
			var posChunk: Vector2i = Vector2i(floor(float(x) / float(ChunkSize)), floor(float(y) / float(ChunkSize)));
			var posXWay: float = (noise.get_noise_1d(posChunk.x + 1458321) + 1.0) * (0.5 - minDistanceFromBorder);
			var posYWay: float = (noise.get_noise_1d(posChunk.y + 9431254) + 1.0) * (0.5 - minDistanceFromBorder);
			var XwayAmplitude: float = noise.get_noise_2d(x * 0.3 + 8421, posChunk.y * 32) * maxWayAmplitude;
			var YwayAmplitude: float = noise.get_noise_2d(posChunk.x * 32, y * 0.3 + 8421) * maxWayAmplitude;
			var posWay: Vector2i = Vector2i((posXWay + posChunk.x + YwayAmplitude) * ChunkSize, (posYWay + posChunk.y + XwayAmplitude) * ChunkSize);
						
			if ((x >= posWay.x + maxWayWidth * ChunkSize or x <= posWay.x - maxWayWidth * ChunkSize) && (y >= posWay.y + maxWayWidth * ChunkSize or y <= posWay.y - maxWayWidth * ChunkSize)):
				Tilemap.set_cell(0, Vector2i(x, y), 1, GrassTile, 0);
			else: 
				Tilemap.set_cell(0, Vector2i(x, y), 1, PathTile, 0);
			
			#generate foliage
			if (noise.get_noise_3d(0, x * 100, y * 100) > 0.4 and Tilemap.get_cell_atlas_coords(0, Vector2i(x, y)) != PathTile):
				match (int((noise.get_noise_3d(100, x, y) + 1.0) * 7) % 3):
					#thin tree
					0: Tilemap.set_cell(1, Vector2i(x, y), 1, Vector2i(9, 8), 0);
					#wide tree
					1: Tilemap.set_cell(1, Vector2i(x, y), 1, Vector2i(0, 8), 0);
					#bush
					2: 
						Tilemap.set_cell(1, Vector2i(x, y), 1, Vector2i(7, 5), 0)
						#test -> changed to calm_grass and instantice bush scene there
						var bush_test:PackedScene = preload("res://scenes/bush1.tscn")
						var bush_spawn = bush_test.instantiate()
						bush_spawn.position = Vector2i(x,y)
						get_tree().root.call_deferred_thread_group("add_child", bush_spawn)
	
	#find all empty spaces where structures can potentially be placed
	for x in range((-Overworld_map_radius - 16.0) / float(ChunkSize) - 1, (Overworld_map_radius + 16.0) / float(ChunkSize)): 
		for y in range((-Overworld_map_radius - 16.0) / float(ChunkSize) - 1, (Overworld_map_radius + 16.0) / float(ChunkSize)):
			var GrassTileDimension: Vector4i = Vector4i(
			int(((noise.get_noise_1d(x + 1458321) + 1.0) * (0.5 - minDistanceFromBorder) + maxWayAmplitude + x) * ChunkSize) + 1,
			int(((noise.get_noise_1d(y + 9431254) + 1.0) * (0.5 - minDistanceFromBorder) + maxWayAmplitude + y) * ChunkSize) + 1,
			int(((noise.get_noise_1d(x + 1 + 1458321) + 1.0) * (0.5 - minDistanceFromBorder) - maxWayAmplitude + x) * ChunkSize + ChunkSize) - 1,
			int(((noise.get_noise_1d(y + 1 + 9431254) + 1.0) * (0.5 - minDistanceFromBorder) - maxWayAmplitude + y) * ChunkSize + ChunkSize) - 1);
		
			#determine the boundry of the map
			var MaxX: int = 2;
			var MaxY: int = 3;
			var MinX: int = 0;
			var MinY: int = 1;
			if (abs(GrassTileDimension[0]) > abs(GrassTileDimension[2])): 
				MaxX = 0;
				MinX = 2;
			if (abs(GrassTileDimension[1]) > abs(GrassTileDimension[3])): 
				MaxX = 1;
				MinY = 3;
			if (sqrt(GrassTileDimension[MinX] * GrassTileDimension[MinX] + GrassTileDimension[MinY] * GrassTileDimension[MinY]) > Overworld_map_radius + 7 * (noise.get_noise_3d(GrassTileDimension[MinX] * 0.7, GrassTileDimension[MinY] * 0.7, 10) + 0.3)):
				continue;
			while(sqrt(GrassTileDimension[MaxX] * GrassTileDimension[MaxX] + GrassTileDimension[MaxY] * GrassTileDimension[MaxY]) > Overworld_map_radius + 7 * (noise.get_noise_3d(GrassTileDimension[MaxX] * 0.7, GrassTileDimension[MaxY] * 0.7, 10) + 0.3)):
				if (abs(GrassTileDimension[MaxX]) > abs(GrassTileDimension[MaxY])):
					if (GrassTileDimension[MaxX] < 0): GrassTileDimension[MaxX] += 1;
					else: GrassTileDimension[MaxX] -= 1;
				else:
					if (GrassTileDimension[MaxY] < 0): GrassTileDimension[MaxY] += 1;
					else: GrassTileDimension[MaxY] -= 1;
			if (GrassTileDimension[3] - GrassTileDimension[1] <= 7 or GrassTileDimension[2] - GrassTileDimension[0] <= 7): continue;
			
			#place structures and paths
			randomize();	
			var StructureIndex: int = randi() % len(Structures);
			var maxStructureHeight: int = 0;
			if (GrassTileDimension[2] - GrassTileDimension[0] > 6 and GrassTileDimension[3] - GrassTileDimension[1] > 6):
				while (Structures[StructureIndex][0][1] > GrassTileDimension[2] - GrassTileDimension[0] or Structures[StructureIndex][0][2] > GrassTileDimension[3] - GrassTileDimension[1]):
					StructureIndex = randi() % len(Structures);
				load_structure(Vector2i(GrassTileDimension[0], GrassTileDimension[3] - Structures[StructureIndex][0][2]), Structures[StructureIndex][1]);
				maxStructureHeight = Structures[StructureIndex][0][2];
			var maxStructureWidth: int = GrassTileDimension[2] - GrassTileDimension[0] - Structures[StructureIndex][0][1] - 1
			StructureIndex = randi() % len(Structures);
			if (maxStructureWidth > 6 and GrassTileDimension[2] - GrassTileDimension[0] > 6):
				while (Structures[StructureIndex][0][1] > maxStructureWidth or Structures[StructureIndex][0][2] > GrassTileDimension[3] - GrassTileDimension[1]):
					StructureIndex = randi() % len(Structures);
				load_structure(Vector2i(GrassTileDimension[2] - Structures[StructureIndex][0][1], GrassTileDimension[3] - Structures[StructureIndex][0][2]), Structures[StructureIndex][1]);
				if (maxStructureHeight < Structures[StructureIndex][0][2]):
					maxStructureHeight = Structures[StructureIndex][0][2];
			
			#generate mossy pathway
			if (abs(GrassTileDimension[3] - GrassTileDimension[1]) - maxStructureHeight + 1 < 6): continue;
			for xx in range(GrassTileDimension[0] - 3, GrassTileDimension[2] + 3):
				for yy in range(GrassTileDimension[3] - maxStructureHeight - 1, GrassTileDimension[3] - maxStructureHeight + 1):
					if (Tilemap.get_cell_atlas_coords(0, Vector2i(xx, yy)) != PathTile):
						Tilemap.set_cell(0, Vector2i(xx, yy), 1, MossyPathTile, 0);
						Tilemap.set_cell(1, Vector2i(xx, yy), -1, MossyPathTile, 0);
			GrassTileDimension[3] = GrassTileDimension[3] - maxStructureHeight - 1;
			
			#generate two more structures
			StructureIndex = randi() % len(Structures);
			if (GrassTileDimension[3] - GrassTileDimension[1] > 6 and GrassTileDimension[2] - GrassTileDimension[0] > 6):
				while (Structures[StructureIndex][0][1] > GrassTileDimension[2] - GrassTileDimension[0] or Structures[StructureIndex][0][2] > GrassTileDimension[3] - GrassTileDimension[1]):
					StructureIndex = randi() % len(Structures);
				load_structure(Vector2i(GrassTileDimension[0], GrassTileDimension[3] - Structures[StructureIndex][0][2]), Structures[StructureIndex][1]);
				maxStructureWidth = GrassTileDimension[2] - GrassTileDimension[0] - Structures[StructureIndex][0][1] - 1
			StructureIndex = randi() % len(Structures);
			if (maxStructureWidth > 6 and GrassTileDimension[3] - GrassTileDimension[1] > 6):
				while (Structures[StructureIndex][0][1] > maxStructureWidth or Structures[StructureIndex][0][2] > GrassTileDimension[3] - GrassTileDimension[1]):
					StructureIndex = randi() % len(Structures);
				load_structure(Vector2i(GrassTileDimension[2] - Structures[StructureIndex][0][1], GrassTileDimension[3] - Structures[StructureIndex][0][2]), Structures[StructureIndex][1]);
			if (abs(GrassTileDimension[3] - GrassTileDimension[1]) - maxStructureHeight + 1 < 6): continue;
					
	var pos: Vector2i = Vector2i(0, 0);
	while(Tilemap.get_cell_atlas_coords(0, pos) != PathTile):
		pos = Vector2i(randi() % 50 - 25, randi() % 50 - 25);
	PlayerSpawnTile = pos;
	$"../player".global_position = Vector2(Tilemap.to_global(map_to_local(PlayerSpawnTile)));
	
func _process(delta: float) -> void:
	pass;
	
	
func save_structure(rect: Vector4i, path: String)-> void:
	var posarray = [];
	for i in range(rect[0], rect[0] + rect[2]):
		for j in range(rect[1], rect[1] + rect[3]):
			posarray.append(Vector2i(i, j));
	Structure_House = Tilemap.get_pattern(0, posarray);
	ResourceSaver.save(Structure_House, path + ".0.tres");
	Structure_House = Tilemap.get_pattern(1, posarray);
	ResourceSaver.save(Structure_House, path + ".1.tres");
	Structure_House = Tilemap.get_pattern(2, posarray);
	ResourceSaver.save(Structure_House, path + ".2.tres");
	
func load_structure(pos: Vector2i, path: String)-> void:
	var loaded_pattern_layer_0: TileMapPattern = ResourceLoader.load(path + ".0.tres")
	var loaded_pattern_layer_1: TileMapPattern = ResourceLoader.load(path + ".1.tres")
	var loaded_pattern_layer_2: TileMapPattern = ResourceLoader.load(path + ".2.tres")
	Tilemap.set_pattern(1, pos, loaded_pattern_layer_0);
	Tilemap.set_pattern(2, pos, loaded_pattern_layer_1);
	Tilemap.set_pattern(3, pos, loaded_pattern_layer_2);

	
func init_SimplexNoise(Seed: int)-> FastNoiseLite:
	var Noise = FastNoiseLite.new();
	Noise.noise_type = FastNoiseLite.TYPE_SIMPLEX;
	Noise.seed = Seed;
	Noise.frequency = 0.05;
	Noise.fractal_type = FastNoiseLite.FRACTAL_FBM;
	Noise.fractal_octaves = 5;	
	return Noise;
	
