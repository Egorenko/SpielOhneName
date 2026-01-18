class_name Dungeon_Room extends Node2D

@onready var tileMap: TileMap = $TileMap;
@onready var player: player1 = $"../player";
@onready var camera: Camera2D = $Camera2D;

func set_active(state: bool) -> void:
	visible = state;
	set_process(state);
	set_physics_process(state);
	print("Room active");
	
func is_pos_on_teleporter(pos: Vector2i) -> int:
	var tile_pos = tileMap.local_to_map(pos);
	var cell_data = tileMap.get_cell_tile_data(1, tile_pos);
	if (cell_data == null): return -1; 
	if (!cell_data.has_custom_data("teleport_tile")): return -1;
	var index: int = cell_data.get_custom_data("teleport_tile") - 1;
	return index;
	
func get_teleport_tile_global_pos(index: int) -> Vector2i:
	index = (index + 2) % 4;
	return tileMap.to_global(tileMap.map_to_local(tileMap.doorPositions[index]));
	
	
