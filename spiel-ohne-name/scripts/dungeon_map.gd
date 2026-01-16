extends TileMap
#
@onready
var Tilemap: TileMap = self;
var teleport_tiles: Array[Vector4i] = [];
var noise: FastNoiseLite;

var min_room_size: Vector2i = Vector2i(3, 2);
var grid_size: int = 15;
var dungeon_size: Vector2i = Vector2i(5, 5);
var room_propability_to_be_void: float = 0.25;
var arrayWithDoorInformation = [];


func _ready() -> void:
	noise = init_SimplexNoise($"../player".SEED);
	
	for i in range(0, dungeon_size.x): 
		var arrayWithDoorInformationRow = []
		for j in range(0, dungeon_size.y):
			for x in range(grid_size * 3 * i, grid_size * 3 * (i + 1)): for y in range(grid_size * 3 * j, grid_size * 3 * (j + 1)):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(3, 0), 0);
			var teleporters_doors: Array[Vector2i]; # saves the position of all four doors
			teleporters_doors.resize(4);
			if (noise.get_noise_2d(i * 100, j * 100) <= (2 * room_propability_to_be_void) - 1):
				arrayWithDoorInformationRow.append(teleporters_doors);		
				continue;
				
				
			var isRoomNextTo: Array[bool] = [false, false, false, false]; # up, right, down, left
			isRoomNextTo[0] = noise.get_noise_2d((i + 0) * 100, (j - 1) * 100) > (2 * room_propability_to_be_void) - 1
			if (j <= 0): isRoomNextTo[0] = false;
			isRoomNextTo[1] = noise.get_noise_2d((i + 1) * 100, (j - 0) * 100) > (2 * room_propability_to_be_void) - 1
			if (i >= dungeon_size.x - 1): isRoomNextTo[1] = false;
			isRoomNextTo[2] = noise.get_noise_2d((i + 0) * 100, (j + 1) * 100) > (2 * room_propability_to_be_void) - 1
			if (j >= dungeon_size.y - 1): isRoomNextTo[2] = false;
			isRoomNextTo[3] = noise.get_noise_2d((i - 1) * 100, (j - 0) * 100) > (2 * room_propability_to_be_void) - 1
			if (i <= 0): isRoomNextTo[3] = false;
			
			
			
			var a = noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 1) * 153, 0);
			var b = noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 1) * 153, 421); 
			var roomSizeAtPos: Vector2i = Vector2i(min_room_size.x + (a + 1) * 0.5 * (grid_size - min_room_size.x), min_room_size.y + (b + 1) * 0.5 * (grid_size - min_room_size.y));
			for x in range(grid_size - roomSizeAtPos.x + i * grid_size * 3, grid_size + i * grid_size * 3): for y in range(grid_size + j * grid_size * 3, grid_size + j * grid_size * 3 + roomSizeAtPos.y):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0), 0);
			for x in range(grid_size - roomSizeAtPos.x + i * grid_size * 3, grid_size + i * grid_size * 3): for y in range(grid_size - 3 + j * grid_size * 3, grid_size + j * grid_size * 3):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0);
			#place tile for door to room below
			if (noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 1) * 153, 421) >= noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 1) * 153, 421)): 
				if (isRoomNextTo[2]):
					teleporters_doors[2] = Vector2i(grid_size - roomSizeAtPos.x * 0.5 + i * grid_size * 3, grid_size + j * grid_size * 3 + roomSizeAtPos.y - 1);
					Tilemap.set_cell(0, teleporters_doors[2], 0, Vector2i(4, 0), 0);		
			#place tile for doot to room on the left
			if (noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 1) * 153, 0) >= noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 0) * 153, 0)):
				if (isRoomNextTo[3]):
					teleporters_doors[3] = Vector2i(grid_size - roomSizeAtPos.x + i * grid_size * 3, grid_size + j * grid_size * 3 + roomSizeAtPos.y * 0.5);
					Tilemap.set_cell(0, teleporters_doors[3], 0, Vector2i(4, 0), 0);		
		
		
			a = noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 1) * 153, 0);
			b = noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 1) * 153, 421); 
			roomSizeAtPos = Vector2i(min_room_size.x + (a + 1) * 0.5 * (grid_size - min_room_size.x), min_room_size.y + (b + 1) * 0.5 * (grid_size - min_room_size.y));
			for x in range(grid_size + i * grid_size * 3, grid_size + i * grid_size * 3 + roomSizeAtPos.x): for y in range(grid_size + j * grid_size * 3, grid_size + j * grid_size * 3 + roomSizeAtPos.y):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0), 0);
			for x in range(grid_size + i * grid_size * 3, grid_size + i * grid_size * 3 + roomSizeAtPos.x): for y in range(grid_size - 3 + j * grid_size * 3, grid_size + j * grid_size * 3):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0);
			#place tile for doot to room below
			if (noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 1) * 153, 421) < noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 1) * 153, 421)):
				if (isRoomNextTo[2]):
					teleporters_doors[2] = Vector2i(grid_size + i * grid_size * 3 + roomSizeAtPos.x * 0.5, grid_size + j * grid_size * 3 + roomSizeAtPos.y - 1)
					Tilemap.set_cell(0, teleporters_doors[2], 0, Vector2i(4, 0), 0);		
			#places tile for door to room on the right
			if (noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 1) * 153, 0) >= noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 0) * 153, 0)):
				if (isRoomNextTo[1]):
					teleporters_doors[1] =  Vector2i(grid_size + roomSizeAtPos.x + i * grid_size * 3 - 1, grid_size + j * grid_size * 3 + roomSizeAtPos.y * 0.5);
					Tilemap.set_cell(0, teleporters_doors[1], 0, Vector2i(4, 0), 0);		
		
		
		
			
			
			a = noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 0) * 153, 0);
			b = noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 0) * 153, 421); 
			roomSizeAtPos = Vector2i(min_room_size.x + (a + 1) * 0.5 * (grid_size - min_room_size.x), min_room_size.y + (b + 1) * 0.5 * (grid_size - min_room_size.y - 3));
			for x in range(grid_size - roomSizeAtPos.x + i * grid_size * 3, grid_size + i * grid_size * 3): for y in range(grid_size - roomSizeAtPos.y + j * grid_size * 3, grid_size + j * grid_size * 3):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0), 0);
			for x in range(grid_size - roomSizeAtPos.x + i * grid_size * 3, grid_size + i * grid_size * 3): for y in range(grid_size - roomSizeAtPos.y - 3 + j * grid_size * 3, grid_size - roomSizeAtPos.y + j * grid_size * 3):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0);
			#places tile for room above
			if (noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 0) * 153, 421) >= noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 0) * 153, 421)):
				if (isRoomNextTo[0]):
					teleporters_doors[0] = Vector2i(grid_size - roomSizeAtPos.x * 0.5 + i * grid_size * 3, grid_size - roomSizeAtPos.y + j * grid_size * 3);
					Tilemap.set_cell(0, teleporters_doors[0], 0, Vector2i(4, 0), 0);		
			#places tile for room to the left
			if (noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 1) * 153, 0) < noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 0) * 153, 0)):
				if (isRoomNextTo[3]):
					teleporters_doors[3] = Vector2i(grid_size - roomSizeAtPos.x + i * grid_size * 3, grid_size + j * grid_size * 3 - roomSizeAtPos.y * 0.5);
					Tilemap.set_cell(0, teleporters_doors[3], 0, Vector2i(4, 0), 0);		
		
			a = noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 0) * 153, 0);
			b = noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 0) * 153, 421); 
			roomSizeAtPos = Vector2i(min_room_size.x + (a + 1) * 0.5 * (grid_size - min_room_size.x), min_room_size.y + (b + 1) * 0.5 * (grid_size - min_room_size.y - 3));
			for x in range(grid_size + i * grid_size * 3, grid_size + i * grid_size * 3 + roomSizeAtPos.x): for y in range(grid_size - roomSizeAtPos.y + j * grid_size * 3, grid_size + j * grid_size * 3):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(1, 0), 0);
			for x in range(grid_size + i * grid_size * 3, grid_size + i * grid_size * 3 + roomSizeAtPos.x): for y in range(grid_size - roomSizeAtPos.y - 3 + j * grid_size * 3, grid_size - roomSizeAtPos.y + j * grid_size * 3):
				Tilemap.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0), 0);
			#places tile for room above
			if (noise.get_noise_3d((3 * i + 0) * 153, (3 * j + 0) * 153, 421) < noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 0) * 153, 421)):
				if (isRoomNextTo[0]):
					teleporters_doors[0] = Vector2i(grid_size + i * grid_size * 3 + roomSizeAtPos.x * 0.5, grid_size - roomSizeAtPos.y + j * grid_size * 3);
					Tilemap.set_cell(0, teleporters_doors[0], 0, Vector2i(4, 0), 0);		
			#places tile for room to the right
			if (noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 1) * 153, 0) < noise.get_noise_3d((3 * i + 1) * 153, (3 * j + 0) * 153, 0)):
				if (isRoomNextTo[1]):
					teleporters_doors[1] = Vector2i(grid_size + roomSizeAtPos.x + i * grid_size * 3 - 1, grid_size + j * grid_size * 3 - roomSizeAtPos.y * 0.5);
					Tilemap.set_cell(0, teleporters_doors[1], 0, Vector2i(4, 0), 0);		
			
			arrayWithDoorInformationRow.append(teleporters_doors);		
		arrayWithDoorInformation.append(arrayWithDoorInformationRow);
		
	for x in range(0, dungeon_size.x): 
		for y in range(0, dungeon_size.y):
			if (arrayWithDoorInformation[x][y][0] != Vector2i(0, 0)):
				teleport_tiles.append(Vector4i(arrayWithDoorInformation[x][y][0].x, arrayWithDoorInformation[x][y][0].y, arrayWithDoorInformation[x][y - 1][2].x, arrayWithDoorInformation[x][y - 1][2].y));
			if (arrayWithDoorInformation[x][y][1] != Vector2i(0, 0)):
				teleport_tiles.append(Vector4i(arrayWithDoorInformation[x][y][1].x, arrayWithDoorInformation[x][y][1].y, arrayWithDoorInformation[x + 1][y][3].x, arrayWithDoorInformation[x + 1][y][3].y));
			if (arrayWithDoorInformation[x][y][2] != Vector2i(0, 0)):
				teleport_tiles.append(Vector4i(arrayWithDoorInformation[x][y][2].x, arrayWithDoorInformation[x][y][2].y, arrayWithDoorInformation[x][y + 1][0].x, arrayWithDoorInformation[x][y + 1][0].y));
			if (arrayWithDoorInformation[x][y][3] != Vector2i(0, 0)):
				teleport_tiles.append(Vector4i(arrayWithDoorInformation[x][y][3].x, arrayWithDoorInformation[x][y][3].y, arrayWithDoorInformation[x - 1][y][1].x, arrayWithDoorInformation[x - 1][y][1].y));
	print("W")
	
	

func _process(delta: float) -> void:
	pass;	
	
func init_SimplexNoise(Seed: int)-> FastNoiseLite:
	var Noise = FastNoiseLite.new();
	Noise.noise_type = FastNoiseLite.TYPE_SIMPLEX;
	Noise.seed = Seed;
	Noise.frequency = 0.05;
	Noise.fractal_type = FastNoiseLite.FRACTAL_FBM;
	Noise.fractal_octaves = 5;	
	return Noise;
