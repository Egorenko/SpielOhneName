extends Node2D

@onready var player: player1;
@onready var tileMap: TileMap = $TileMap;

func _ready() -> void:
	Seed.player_scene.get_node("Camera2D").make_current();

func _process(delta: float) -> void:
	
	var tileData: TileData = tileMap.get_cell_tile_data(2, tileMap.local_to_map(Seed.player_scene.position));
	if (tileData == null):
		Seed.player_scene.can_teleport = true;
		return;
	if (tileData.get_custom_data("Teleporter") and Seed.player_scene.can_teleport):
		Seed.player_scene.can_teleport = false;
		Seed.player_past_Overworld_position = Seed.player_scene.position;
		Seed.player_has_pos = true;
		get_tree().change_scene_to_file("res://scenes/dungeon_room_manager.tscn");
