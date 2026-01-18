extends Node2D

@export var num_entities: int = 35
@export var nav_layer: int = 0

@onready var ritter: PackedScene = preload("res://scenes/ritter.tscn")
@onready var skeleton : PackedScene = preload("res://scenes/skelleton.tscn")
@onready var tile_map: TileMap = $TileMap

var navigation_cells: Array[Vector2i] = []

func _ready() -> void:
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
