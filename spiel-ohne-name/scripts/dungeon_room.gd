class_name Dungeon_Room extends Node2D

@onready var tileMap: TileMap = $TileMap;
@onready var player: player1 = $"../player";

@export var num_entities: int = 5
@export var nav_layer: int = 0

@onready var ritter: PackedScene = preload("res://scenes/ritter.tscn")
@onready var skeleton : PackedScene = preload("res://scenes/skelleton.tscn")
@onready var tile_map: TileMap = $TileMap

var navigation_cells: Array[Vector2i] = []

func spawn_enemys(count: int) -> void:
	num_entities = count;
	randomize()
	cache_navigation_cells()
	spawn_entities()

func spawn_entities() -> void:
	for i in num_entities:
		spawn_entity()

func spawn_entity() -> void:
	if navigation_cells.is_empty():
		push_warning("Keine gültigen Navigation-Zellen gefunden.")
		return

	var entitis = [ritter, skeleton]
	var entity := entitis.pick_random().instantiate() as Node2D
	
	entity.global_position = get_random_navigation_position()
	add_child(entity)

func cache_navigation_cells() -> void:
	navigation_cells.clear()

	for cell in tile_map.get_used_cells(nav_layer):
		var data := tile_map.get_cell_tile_data(nav_layer, cell)
		if data and data.get_navigation_polygon(0):
			navigation_cells.append(cell)

func get_random_navigation_position() -> Vector2:
	var cell: Vector2i = navigation_cells.pick_random()
	return tile_map.map_to_local(cell)

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
	
	
