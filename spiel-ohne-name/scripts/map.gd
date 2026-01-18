extends Node2D

@onready var player: player1 = $player;
@onready var tileMap: TileMap = $TileMap;

func _process(delta: float) -> void:
	var tileData: TileData = tileMap.get_cell_tile_data(2, tileMap.local_to_map(player.position));
	if (tileData == null):
		player.can_teleport = true;
		return;
	if (tileData.get_custom_data("Teleporter") and player.can_teleport):
		player.can_teleport = false;
		Seed.player_past_Overworld_position = player.position;
		Seed.player_has_pos = true;
		get_tree().change_scene_to_file("res://scenes/dungeon_room_manager.tscn");
