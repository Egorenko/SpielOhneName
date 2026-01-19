extends Node2D

@onready var player: player1;
@onready var tileMap: TileMap = $TileMap;

func _ready() -> void:
	Player.player_scene.get_node("Camera2D").make_current();

func _process(delta: float) -> void:
	var tileData: TileData = tileMap.get_cell_tile_data(2, tileMap.local_to_map(Player.player_scene.position));
	if (tileData == null):
		Player.player_scene.can_teleport = true;
		return;
	if (tileData.get_custom_data("Teleporter") and Player.player_scene.can_teleport):
		Player.player_scene.can_teleport = false;
		Player.player_scene.past_Overworld_position = Player.player_scene.global_position;
		get_tree().change_scene_to_file("res://scenes/dungeon_room_manager.tscn");
