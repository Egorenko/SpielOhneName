extends TileMap

@onready
var Tilemap: TileMap = self
var noise: FastNoiseLite;
var Structure_House: TileMapPattern;

var GrassTile: Vector2i = Vector2i(7, 0);

func _ready() -> void:
	save_structure(Vector4i(0, 0, 0, 0), "");
	var loaded_pattern_layer_0: TileMapPattern = ResourceLoader.load("res://structures/Structure_House_3.0.tres")
	var loaded_pattern_layer_1: TileMapPattern = ResourceLoader.load("res://structures/Structure_House_3.1.tres")

	
	noise = init_SimplexNoise($"../player".SEED);
	
	#Tilemap.set_cell(0, Vector2i(randi() % 50 - 25, randi() % 50 - 25), 1, GrassTile, 0);
	
	var ChunkSize: int = 25; # Chunksize in Tiles
	var minDistanceFromBorder: float = 0.15; # distance the middle of the path should have to the border of the chunk in percent of tiles
	var maxWayAmplitude: float = 0.1; # Maximum amplitude the path should have in percent of tiles. Full amplitude is two times this value since it can add and subtract the max amplitude
	var maxWayWidth: float = 0.1; # maximum width of the path in percent of tiles. full width is two times this value for it can be added below and above the path
	
	for x in range(-50, 50):
		for y in range(-50, 50):
			var posChunk: Vector2i = Vector2i(floor(float(x) / float(ChunkSize)), floor(float(y) / float(ChunkSize)));
			var posXWay: float = (noise.get_noise_1d(posChunk.x + 1458321) + 1.0) * (0.5 - minDistanceFromBorder);
			var posYWay: float = (noise.get_noise_1d(posChunk.y + 9431254) + 1.0) * (0.5 - minDistanceFromBorder);
			var XwayAmplitude: float = noise.get_noise_2d(x * 0.3 + 8421, posChunk.y * 32) * maxWayAmplitude;
			var YwayAmplitude: float = noise.get_noise_2d(posChunk.x * 32, y * 0.3 + 8421) * maxWayAmplitude;
			var posWay: Vector2i = Vector2i((posXWay + posChunk.x + YwayAmplitude) * ChunkSize, (posYWay + posChunk.y + XwayAmplitude) * ChunkSize);
			if ((x >= posWay.x + maxWayWidth * ChunkSize or x <= posWay.x - maxWayWidth * ChunkSize) && (y >= posWay.y + maxWayWidth * ChunkSize or y <= posWay.y - maxWayWidth * ChunkSize)):
				Tilemap.set_cell(0, Vector2i(x, y), 1, GrassTile, 0);
			else: 
				Tilemap.set_cell(0, Vector2i(x, y), 1, Vector2i(7, 1), 0);
				
	var GrassTileDimension: Vector4i = Vector4i(
		int(((noise.get_noise_1d(0 + 1458321) + 1.0) * (0.5 - minDistanceFromBorder) + maxWayAmplitude) * ChunkSize) + 1,
		int(((noise.get_noise_1d(0 + 9431254) + 1.0) * (0.5 - minDistanceFromBorder) + maxWayAmplitude) * ChunkSize) + 1,
		int(((noise.get_noise_1d(1 + 1458321) + 1.0) * (0.5 - minDistanceFromBorder) - maxWayAmplitude) * ChunkSize + ChunkSize) - 1,
		int(((noise.get_noise_1d(1 + 9431254) + 1.0) * (0.5 - minDistanceFromBorder) - maxWayAmplitude) * ChunkSize + ChunkSize) - 1);
		
	for x in range(GrassTileDimension.x, GrassTileDimension.z):
		for y in range(GrassTileDimension.y, GrassTileDimension.w):
			Tilemap.set_cell(1, Vector2i(x, y), 1, Vector2i(2, 0), 0);
			
	Tilemap.set_pattern(2, Vector2i(10, 10), loaded_pattern_layer_1);
	Tilemap.set_pattern(1, Vector2i(10, 10), loaded_pattern_layer_0);
			
	
	
func _process(delta: float) -> void:
	pass;
	
	
func save_structure(rect: Vector4i, path: String)-> void:
	var posarray = [];
	for i in range(rect[0], rect[0] + rect[2]):
		for j in range(rect[1], rect[1] + rect[3]):
			posarray.append(Vector2i(i, j));
	Structure_House = Tilemap.get_pattern(0, posarray);
	ResourceSaver.save(Structure_House, "res://structures/Structure_House_3.0.tres");
	Structure_House = Tilemap.get_pattern(1, posarray);
	ResourceSaver.save(Structure_House, "res://structures/Structure_House_3.1.tres");	
 	
func init_SimplexNoise(Seed: int)-> FastNoiseLite:
	var Noise = FastNoiseLite.new();
	Noise.noise_type = FastNoiseLite.TYPE_SIMPLEX;
	Noise.seed = Seed;
	Noise.frequency = 0.05;
	Noise.fractal_type = FastNoiseLite.FRACTAL_FBM;
	Noise.fractal_octaves = 5;	
	return Noise;
	
